defmodule ExChargebee.Resource do
  @moduledoc false

  defmacro __using__(opts \\ []) do
    get_operations = Keyword.get(opts, :get_operations, [])
    post_operations = Keyword.get(opts, :post_operations, [])

    quote location: :keep do
      alias ExChargebee.Interface
      import ExChargebee.Resource

      @resource __MODULE__
                |> Module.split()
                |> List.last()
                |> Macro.underscore()
      @resource_plural Inflex.pluralize(@resource)

      def retrieve(resource_id, opts \\ []) do
        get_resource(resource_id, "", opts)
      rescue
        ExChargebee.NotFoundError -> nil
      end

      def list(params \\ %{}, opts \\ []) do
        params
        |> stream_list(opts)
        |> Enum.to_list()
      end

      def stream_list(params \\ %{}, opts \\ []) do
        Stream.unfold(0, fn
          nil ->
            nil

          0 ->
            response = Interface.get(resource_base_path(), params, opts)

            list = Map.get(response, "list")
            next_offset = Map.get(response, "next_offset")

            {list, next_offset}

          offset ->
            params = Map.merge(params, %{"offset" => offset})
            response = Interface.get(resource_base_path(), params, opts)

            {Map.get(response, "list"), Map.get(response, "next_offset")}
        end)
        |> Stream.flat_map(& &1)
        |> Stream.map(&Map.get(&1, @resource))
      end

      def create(params, path \\ "", opts \\ []) do
        resource_base_path()
        |> Kernel.<>(path)
        |> Interface.post(params, opts)
        |> Map.get(@resource)
      end

      def get_resource(resource_id, endpoint \\ "", params \\ %{}, opts \\ []) do
        resource_id
        |> resource_path()
        |> Kernel.<>(endpoint)
        |> Interface.get(params, opts)
        |> Map.get(@resource)
      end

      def post_resource(resource_id, endpoint, params, opts \\ []) do
        resource_id
        |> resource_path()
        |> Kernel.<>(endpoint)
        |> Interface.post(params, opts)
        |> Map.get(@resource)
      end

      def create_for_parent(parent_path, params, path \\ "", opts \\ []) do
        parent_path
        |> Kernel.<>(resource_base_path())
        |> Kernel.<>(path)
        |> Interface.post(params, opts)
        |> Map.get(@resource)
      end

      def update(resource_id, params, path \\ "", opts \\ []) do
        resource_id
        |> resource_path()
        |> Kernel.<>(path)
        |> Interface.post(params, opts)
        |> Map.get(@resource)
      end

      def resource_base_path do
        "/#{@resource_plural}"
      end

      def resource_path(id) do
        encoded_id = id |> to_string |> URI.encode()

        "#{resource_base_path()}/#{encoded_id}"
      end

      ExChargebee.Resource.generate_operations(unquote(get_operations), "get")
      ExChargebee.Resource.generate_operations(unquote(post_operations), "post")
    end
  end

  defmacro generate_operations(operations, verb) do
    for operation <- operations do
      quote do
        @spec unquote(operation)(String.t(), map()) :: map() | nil
        def unquote(operation)(subscription_id, params, opts \\ []) do
          apply(__MODULE__, :"#{unquote(verb)}_resource", [
            subscription_id,
            "/#{unquote(operation)}",
            params,
            opts
          ])
        end
      end
    end
  end
end
