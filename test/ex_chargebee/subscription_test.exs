defmodule ExChargebee.SubscriptionTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  describe "post_operations" do
    post_operations = ExChargebee.Subscription.operations()[:post_operations]

    Enum.map(post_operations, fn operation ->
      test "#{operation}" do
        operation = unquote(operation)
        mock_post(operation, "sub-a")
        assert apply(ExChargebee.Subscription, operation, ["sub-a", %{}])
      end
    end)
  end

  describe "get_operations" do
    get_operations = ExChargebee.Subscription.operations()[:get_operations]

    Enum.map(get_operations, fn operation ->
      test "#{operation}" do
        operation = unquote(operation)
        mock_get(operation, "sub-a")
        assert apply(ExChargebee.Subscription, operation, ["sub-a", %{}])
      end
    end)

    test "when opts site is passed" do
      Application.put_env(:ex_chargebee, :test_site, namespace: "baz-bar", api_key: "foo")

      expect(
        ExChargebee.HTTPoisonMock,
        :get!,
        fn url, _headers ->
          assert url ==
                   "https://baz-bar.chargebee.com/api/v2/subscriptions/sub-a/contract_terms"

          %{
            status_code: 200,
            body: '{"subscription": {"id": "sub-a"}}'
          }
        end
      )

      assert apply(ExChargebee.Subscription, :contract_terms, ["sub-a", %{}, [site: :test_site]])
    end
  end

  def mock_post(operation, id) do
    expect(
      ExChargebee.HTTPoisonMock,
      :post!,
      fn url, _data, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/subscriptions" <>
                   "/" <> id <> "/" <> to_string(operation)

        %{
          status_code: 200,
          body: '{"subscription": {"id": "sub-a"}}'
        }
      end
    )
  end

  def mock_get(operation, id) do
    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/subscriptions/#{id}/#{operation}"

        %{
          status_code: 200,
          body: '{"subscription": {"id": "sub-a"}}'
        }
      end
    )
  end
end
