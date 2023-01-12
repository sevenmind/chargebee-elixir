defmodule ExChargebee.Interface do
  @moduledoc """
  A low level http interface for interacting with Chargebee V2 HTTP Endpoints

  Configuration:
   - Authorization loaded from Application env `:ex_chargebee, :api_key`
   - Chargebee namespace scoping loaded from  Application env  `:ex_chargebee, :namespace`
   - Alternative HTTP Clients configured from  Application env `:ex_chargebee, :http_client` (i.e. in testing)
  """

  def get(path) do
    get(path, %{})
  end

  def get(path, params) do
    params_string = URI.encode_query(params)

    url =
      [fullpath(path), params_string]
      |> Enum.filter(fn s -> String.length(s) > 0 end)
      |> Enum.join("?")

    http_client().get!(url, headers())
    |> handle_response(path, params)
  end

  def post(path, data) do
    body =
      data
      |> serialize()
      |> URI.encode_query()

    http_client().post!(
      fullpath(path),
      body,
      headers() ++ [{"Content-Type", "application/x-www-form-urlencoded"}]
    )
    |> handle_response(path, data)
  end

  defp handle_response(%{body: body, status_code: 200}, _, _) do
    Jason.decode!(body)
  end

  defp handle_response(%{body: body, status_code: 400}, path, data) do
    message =
      body
      |> Jason.decode!()
      |> Map.get("message")

    raise ExChargebee.InvalidRequestError, message: message, path: path, data: data
  end

  defp handle_response(%{status_code: 401}, path, data) do
    raise ExChargebee.UnauthorizedError, path: path, data: data
  end

  defp handle_response(%{status_code: 404}, path, data) do
    raise ExChargebee.NotFoundError, path: path, data: data
  end

  defp handle_response(%{status_code: 429}, path, data) do
    raise ExChargebee.RateLimitError, path: path, data: data
  end

  defp handle_response(%{} = response, path, data) do
    raise ExChargebee.UnknownError, path: path, data: data, response: response
  end

  defp http_client do
    Application.get_env(:ex_chargebee, :http_client, HTTPoison)
  end

  defp fullpath(path) do
    # TODO someday: Allow multiple Chargebee Interfaces with multiple namespaces
    namespace = Application.get_env(:ex_chargebee, :namespace)
    "https://#{namespace}.chargebee.com/api/v2#{path}"
  end

  defp headers do
    api_key =
      :ex_chargebee
      |> Application.get_env(:api_key)
      |> Kernel.<>(":")
      |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key}
    ]
  end

  # serialize/3 is a 1:1 adaptation of Chargebee-Ruby `Chargebee::Util.serialize/3`
  # from https://github.com/chargebee/chargebee-ruby/blob/42f4aa5e58d5760d9f66d3aff02f8389faa6e68f/lib/chargebee/util.rb#L5
  def serialize(value, prefix \\ nil, index \\ nil)

  def serialize(value, prefix, index) when is_map(value) do
    Enum.flat_map(value, fn
      {_k, nil} ->
        []

      {k, v} when k in ["metadata", :metadata] and is_map(v) ->
        [{to_string(k), Jason.encode!(v)}]

      {k, v} when is_map(v) or is_list(v) ->
        pre = if is_nil(prefix), do: to_string(k), else: "#{prefix}[#{k}]"
        # fix = if is_nil(index), do: "", else: "[#{index}]"

        serialize(v, pre, index)

      {k, v} ->
        pre = if is_nil(prefix), do: to_string(k), else: "#{prefix}[#{k}]"
        fix = if is_nil(index), do: "", else: "[#{index}]"

        key = pre <> fix
        [{key, to_string(v)}]
    end)
    |> Map.new()
  end

  def serialize(value, prefix, nil) when is_list(value) do
    value
    |> Enum.with_index()
    |> Enum.flat_map(fn {item, i} -> serialize(item, prefix, i) end)
    |> Map.new()
  end

  # Apparently Second Degree nested arrays are just encoded as json values
  def serialize(value, prefix, index) when is_list(value) do
    value = Jason.encode!(value)

    key = "#{prefix}[#{index}]"

    [{key, value}]
  end

  def serialize(_value, nil, nil) do
    raise ArgumentError, "Only hash or arrays are allowed as value"
  end

  def serialize(value, prefix, index) do
    key = "#{prefix}[#{index}]"

    [{key, value}]
  end
end
