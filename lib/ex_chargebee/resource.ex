defmodule ExChargebee.Resource do
  @moduledoc false
  defmacro __using__(_) do
    quote location: :keep do
      alias ExChargebee.Interface

      @resource __MODULE__
                |> Module.split()
                |> List.last()
                |> Macro.underscore()
      @resource_plural Inflex.pluralize(@resource)

      def retrieve(id) do
        id |> resource_path() |> Interface.get() |> Map.get(@resource)
      rescue
        ExChargebee.NotFoundError -> nil
      end

      def list(params \\ %{}) do
        params
        |> stream_list()
        |> Enum.to_list()
      end

      def stream_list(params \\ %{}) do
        Stream.unfold(0, fn
          nil ->
            nil

          0 ->
            response = Interface.get(resource_base_path(), params)

            list = Map.get(response, "list")
            next_offset = Map.get(response, "next_offset")

            {list, next_offset}

          offset ->
            params = Map.merge(params, %{"offset" => offset})
            response = Interface.get(resource_base_path(), params)

            {Map.get(response, "list"), Map.get(response, "next_offset")}
        end)
        |> Stream.flat_map(& &1)
        |> Stream.map(&Map.get(&1, @resource))
      end

      def create(params, path \\ "") do
        resource_base_path()
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def post_resource(resource_id, endpoint, params) do
        resource_id
        |> resource_path()
        |> Kernel.<>(endpoint)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def create_for_parent(parent_path, params, path \\ "") do
        parent_path
        |> Kernel.<>(resource_base_path())
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def update(resource_id, params, path \\ "") do
        resource_id
        |> resource_path()
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def resource_base_path do
        "/#{@resource_plural}"
      end

      def resource_path(id) do
        encoded_id = id |> to_string |> URI.encode()

        "#{resource_base_path()}/#{encoded_id}"
      end
    end
  end
end
