defmodule ExChargebee.Event do
  @moduledoc """
  an interface for interacting with Events
  """
  @resource "event"
  alias ExChargebee.Interface

  def retrieve(id, opts \\ []) do
    id |> resource_path() |> Interface.get(%{}, opts) |> Map.get(@resource)
  rescue
    ExChargebee.NotFoundError -> nil
  end

  def list(params \\ %{}, opts \\ []) do
    # Should pagination be by default?
    case Interface.get(resource_base_path(), params, opts) do
      %{"list" => current_list, "next_offset" => next_offset} ->
        Enum.map(current_list, &Map.get(&1, @resource)) ++
          __MODULE__.list(Map.merge(params, %{"offset" => next_offset}))

      %{"list" => current_list} ->
        Enum.map(current_list, &Map.get(&1, @resource))
    end
  end

  defp resource_base_path do
    "/#{@resource}s"
  end

  defp resource_path(id) do
    "#{resource_base_path()}/#{id}"
  end
end
