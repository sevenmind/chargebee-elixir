defmodule ExChargebee.Interface do
  @moduledoc """
  A low level http interface for interacting with Chargebee V2 HTTP Endpoints

  Configuration:
   - Authorization loaded from Application env `:ex_chargebee, :api_key`
   - Chargebee namespace scoping loaded from  Application env  `:ex_chargebee, :namespace`
   - Alternative HTTP Clients configured from  Application env `:ex_chargebee, :http_client` (i.e. in testing)
  """
  alias ExChargebee.Interface.ParameterSerializer

  def get(path) do
    get(path, %{})
  end

  def get(path, params, opts \\ []) do
    params_string =
      params
      |> ParameterSerializer.serialize()
      |> URI.encode_query()

    url =
      [fullpath(path, opts), params_string]
      |> Enum.filter(fn s -> String.length(s) > 0 end)
      |> Enum.join("?")

    http_client().get!(url, headers(opts))
    |> handle_response(path, params)
  end

  def post(path, data, opts \\ []) do
    body =
      data
      |> ParameterSerializer.serialize()
      |> URI.encode_query()

    fullpath = fullpath(path, opts)
    client = http_client()
    headers = headers(opts) ++ [{"Content-Type", "application/x-www-form-urlencoded"}]

    client.post!(
      fullpath,
      body,
      headers
    )
    |> handle_response(path, data)
  end

  defp handle_response(%{body: body, status_code: status}, _, _)
       when status >= 200 and status < 300 do
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

  defp fullpath(path, opts) do
    namespace = config(opts, :namespace)
    "https://#{namespace}.chargebee.com/api/v2#{path}"
  end

  defp headers(opts) do
    api_key =
      opts
      |> config(:api_key)
      |> Kernel.<>(":")
      |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key}
    ]
  end

  defp config(opts, path) do
    case opts[:site] do
      nil ->
        Application.get_all_env(:ex_chargebee)

      site ->
        Application.get_env(:ex_chargebee, site)
    end
    |> Keyword.fetch!(path)
  end

  def stream_list(path, params, opts) do
    Stream.unfold(0, fn
      nil ->
        nil

      0 ->
        response = get(path, params, opts)

        list = Map.get(response, "list")
        next_offset = Map.get(response, "next_offset")

        {list, next_offset}

      offset ->
        params = Map.merge(params, %{"offset" => offset})
        response = get(path, params, opts)

        {Map.get(response, "list"), Map.get(response, "next_offset")}
    end)
  end

  def stream_list(path, params, opts, resource_name) do
    stream_list(path, params, opts)
    |> Stream.flat_map(& &1)
    |> Stream.map(&Map.get(&1, resource_name))
  end

  def post_resource(path, params, opt, resource_name) do
    post(path, params, opt)
    |> Map.get(resource_name)
  end
end
