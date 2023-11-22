defmodule ExChargebee.Resource do
  @moduledoc """
  A macro for generating simple chargebee http interfaces. 

  Chargebee's API structure is generally consistent, but some endpoints are
  decidedly atypical. 



  Typically Endpoints support the following Standard Operations:
    - create (POST /resource) (mostly deprecated or internal)
    - list (GET /resource)
    - retrieve (GET /resource/:id)
    - update (POST /resource/:id)
    - delete (POST /resource/:id/delete)

  To disable any of these operations, pass a list of operations to the `:stdops`
  option.

  Some endpoints support additional operations. To add these operations, pass a
  list of operations to the `:get_operations`, `:post_operations`,
  `:list_operations`, or `:post_root_operations` options.


  Types of operations: 
   - Get Operations (GET /resource/:id/:operation)
   - Post Operations (POST /resource/:id/:operation)
   - List Operations (GET /resource/:operation)
   - Post Root Operations (POST /resource/:operation)


  A better name for "Post Root Operations" would be "Create Operations", but
  that would be confusing because of the `create` operation. 


  Example:

  ```elixir
  defmodule ExChargebee.Subscription do
    use ExChargebee.Resource,
      post_operations: [
        :add_charge_at_term_end,
        :cancel_for_items,
        :change_term_end,
        :charge_future_renewals,
        :delete,
        :edit_advance_invoice_schedule,
        :import_contract_term,
        :import_for_items,
        :override_billing_profile,
        :pause,
        :reactivate,
        :regenerate_invoice,
        :remove_advance_invoice_schedule,
        :remove_coupons,
        :remove_scheduled_cancellation,
        :remove_scheduled_changes,
        :remove_scheduled_pause,
        :remove_scheduled_resumption,
        :resume,
        :retrieve_advance_invoice_schedule,
        :subscription_for_items,
        :update_for_items
      ],
      get_operations: [:contract_terms, :discounts, :retrieve_with_scheduled_changes]

    def import_unbilled_charges(params, opts \\ []) do
      post_resource("import_unbilled_charges", "/import_unbilled_charges", params, opts)
    end
  end
  ```

  """
  alias ExChargebee.Interface

  defmacro __using__(opts \\ []) do
    module = __CALLER__.module
    resource = module |> Module.split() |> List.last() |> Macro.underscore()

    quote location: :keep do
      alias ExChargebee.Interface
      import ExChargebee.Resource

      @resource __MODULE__
                |> Module.split()
                |> List.last()
                |> Macro.underscore()
      @resource_plural Inflex.pluralize(@resource)

      defp resource_base_path(path \\ "")

      defp resource_base_path("") do
        "/#{@resource_plural}"
      end

      defp resource_base_path("/" <> _rest = path) do
        "/#{@resource_plural}#{path}"
      end

      defp resource_base_path(path) do
        "/#{@resource_plural}/#{path}"
      end

      defp resource_path(id, path \\ "")

      defp resource_path(id, "") do
        encoded_id = id |> to_string |> URI.encode()

        "#{resource_base_path()}/#{encoded_id}"
      end

      defp resource_path(id, "/" <> _rest = path) do
        encoded_id = id |> to_string |> URI.encode()

        "#{resource_base_path()}/#{encoded_id}#{path}"
      end

      defp resource_path(id, path) do
        encoded_id = id |> to_string |> URI.encode()

        "#{resource_base_path()}/#{encoded_id}/#{path}"
      end

      # expose operations for testing
      @spec operations() :: Keyword.t()
      def operations do
        Keyword.take(unquote(opts), [
          :get_operations,
          :post_operations,
          :list_operations,
          :post_root_operations,
          :stdops
        ])
        |> Keyword.update(:list_operations, [], &Enum.map(&1, fn v -> :"list_#{v}" end))
        |> Keyword.update(:list_root_operations, [], &Enum.map(&1, fn v -> :"list_#{v}" end))
      end

      def operations(group) do
        Keyword.get(operations(), group, [])
      end

      unquote(define_stdops(opts, resource))
      unquote(define_operations(opts, resource))
    end
  end

  defp define_operations(opts, resource) do
    get_operations = Keyword.get(opts, :get_operations, [])
    post_operations = Keyword.get(opts, :post_operations, [])
    list_operations = Keyword.get(opts, :list_operations, [])
    list_root_operations = Keyword.get(opts, :list__root_operations, [])
    post_root_operations = Keyword.get(opts, :post_root_operations, [])

    quote location: :keep do
      unquote(generate_operations(get_operations, :get, resource))
      unquote(generate_operations(post_operations, :post, resource))
      unquote(generate_operations(list_operations, :list, resource))
      unquote(generate_operations(list_root_operations, :list_root, resource))
      unquote(generate_operations(post_root_operations, :create, resource))
    end
  end

  defp define_stdops(opts, resource) do
    stdops =
      Keyword.get(opts, :stdops, [
        :create,
        :retrieve,
        :list,
        :update,
        :delete
      ])

    if stdops && is_list(stdops) do
      for op <- Enum.uniq(stdops) do
        defstdop(op, resource)
      end
    end
  end

  def generate_operations(operations, :list_root, resource) do
    for operation <- operations do
      operation_name = :"list_#{operation}"

      quote location: :keep do
        @doc """
        Returns a list of #{@resource_plural} #{unquote(operation)}.

        Pagination is handled automatically.
        For more information see [the Chargebee Documentation](https://apidocs.chargebee.com/docs/api/#{Inflex.pluralize(unquote(resource))}##{unquote(operation_name)})
        """
        @spec unquote(operation_name)(map(), keyword()) :: [map()] | nil
        def unquote(operation_name)(params \\ %{}, opts \\ []) do
          if Keyword.get(opts, :paginate, true) do
            unquote(operation)
            |> resource_base_path()
            |> Interface.stream_list(params, opts, unquote(resource))
            |> Enum.to_list()
          else
            unquote(operation)
            |> resource_base_path()
            |> Interface.get(params, opts)
            |> Map.update("list", [], &Map.get(&1, unquote(resource)))
          end
        end
      end
    end
  end

  def generate_operations(operations, :list, resource) do
    for operation <- operations do
      operation_name = :"list_#{operation}"

      quote location: :keep do
        @doc """
        Returns a list of #{@resource_plural} #{unquote(operation)}.

        Pagination is handled automatically.
        For more information see [the Chargebee Documentation](https://apidocs.chargebee.com/docs/api/#{Inflex.pluralize(unquote(resource))}##{unquote(operation_name)})
        """
        @spec unquote(operation_name)(String.t(), map(), keyword()) :: [map()] | nil
        def unquote(operation_name)(resource_id, params \\ %{}, opts \\ []) do
          path = resource_path(resource_id, unquote(operation))
          resource_name = Inflex.singularize(unquote(operation))

          if Keyword.get(opts, :paginate, true) do
            path
            |> Interface.stream_list(params, opts, resource_name)
            |> Enum.to_list()
          else
            path
            |> Interface.get(params, opts)
            |> Map.update("list", [], &Map.get(&1, resource_name))
          end
        end
      end
    end
  end

  def generate_operations(operations, :create, resource) do
    for operation <- operations do
      quote location: :keep do
        @doc """
        Perform a #{unquote(resource)} #{unquote(operation)}.

        Find more information in [the Chargebee Documentation](https://apidocs.chargebee.com/docs/api/#{Inflex.pluralize(unquote(resource))}##{unquote(operation)})
        """
        @spec unquote(operation)(map(), keyword()) :: map() | nil
        def unquote(operation)(params, opts \\ []) do
          unquote(operation)
          |> resource_base_path()
          |> Interface.post(params, opts)
          |> Map.get(unquote(resource))
        end
      end
    end
  end

  def generate_operations(operations, verb, resource) do
    for operation <- operations do
      {resource, operation} =
        case operation do
          {resource, operation} -> {resource, operation}
          operation -> {resource, operation}
        end

      quote location: :keep do
        @doc """
        Perform a #{unquote(operation)} on individual #{unquote(resource)}.

        Find more information in [the Chargebee Documentation](https://apidocs.chargebee.com/docs/api/#{Inflex.pluralize(unquote(resource))}##{unquote(operation)})
        """
        @spec unquote(operation)(String.t(), map(), keyword()) :: map() | nil
        def unquote(operation)(resource_id, params \\ %{}, opts \\ []) do
          path = resource_path(resource_id, "/#{unquote(operation)}")

          apply(Interface, unquote(verb), [path, params, opts])
          |> Map.get(unquote(resource))
        end
      end
    end
  end

  def defstdop(:retrieve, resource) do
    quote location: :keep do
      resource_plural = Inflex.pluralize(unquote(resource))

      @moduledoc """
      An interface for Interacting with #{resource_plural}


      For More information see [Chargebee #{unquote(resource)} Documentation](https://apidocs.chargebee.com/docs/api/#{resource_plural})
      """
      @spec retrieve(String.t(), keyword()) :: map() | nil
      def retrieve(resource_id, opts \\ []) do
        resource_path(resource_id, "")
        |> Interface.get(opts)
        |> Map.get(unquote(resource))
      rescue
        ExChargebee.NotFoundError -> nil
      end
    end
  end

  def defstdop(:list, resource) do
    quote location: :keep do
      resource_plural = Inflex.pluralize(unquote(resource))

      @doc """
      Returns a list of #{resource_plural}. Pagination is handled automatically unless the opt `paginate` is set to false.

      opts:
        - site: the site to use for the request. Defaults to the default site.
        - paginate: whether to paginate the results. Defaults to false. If false,
          all results will be returned.
      """
      @spec list(map(), keyword()) :: [map()] | nil
      def list(params \\ %{}, opts \\ []) do
        if Keyword.get(opts, :paginate, true) do
          stream_list(params, opts)
          |> Enum.to_list()
        else
          resource_base_path()
          |> Interface.get(params, opts)
          |> Map.update("list", [], &Map.get(&1, unquote(resource)))
        end
      end

      @doc """
      Returns a stream of #{resource_plural}. Pagination is handled
      automatically as the stream is consumed.

      """
      @spec stream_list(map(), keyword()) :: Enumerable.t()
      def stream_list(params \\ %{}, opts \\ []) do
        Interface.stream_list(resource_base_path(), params, opts, unquote(resource))
      end
    end
  end

  def defstdop(:create, resource) do
    quote location: :keep do
      resource = unquote(resource)
      resource_plural = Inflex.pluralize(unquote(resource))

      @doc """
      Creates a #{resource}.

      Find more information in [the Chargebee Documentation](https://apidocs.chargebee.com/docs/api/#{resource_plural}#create_#{resource})
      """
      @spec create(map(), keyword()) :: map() | nil
      def create(params, opts \\ []) do
        resource_base_path()
        |> Interface.post(params, opts)
        |> Map.get(unquote(resource))
      end
    end
  end

  def defstdop(:update, resource) do
    quote location: :keep do
      resource = unquote(resource)
      resource_plural = Inflex.pluralize(unquote(resource))

      @doc """
      Updates a #{resource}.

      Find more information in [the Chargebee Documentation](https://apidocs.chargebee.com/docs/api/#{resource_plural}#update_#{resource})
      """
      @spec update(String.t(), map(), keyword()) :: map() | nil
      def update(resource_id, params, opts \\ []) do
        resource_id
        |> resource_path()
        |> Interface.post(params, opts)
        |> Map.get(unquote(resource))
      end
    end
  end

  def defstdop(:delete, resource) do
    # quote location: :keep do
    ExChargebee.Resource.generate_operations([:delete], :post, resource)
    # end
  end

  def defstdop(other, resource) do
    quote location: :keep do
      # raise an error if the operation is not supported
      raise """
      #{inspect(unquote(other))} is not a supported operation for #{unquote(resource)}
      """
    end
  end
end
