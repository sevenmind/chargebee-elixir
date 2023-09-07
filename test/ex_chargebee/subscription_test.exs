defmodule ExChargebee.SubscriptionTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  def subject do
    ExChargebee.Subscription.create_for_customer(
      "cus_1",
      %{
        plan_id: "plan-a",
        addons: [
          %{id: "addon-a"},
          %{id: "addon-b"}
        ]
      }
    )
  end

  describe "create_for_customer" do
    test "incorrect auth" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscriptions"

          assert URI.decode(data) == "addons[id][0]=addon-a&addons[id][1]=addon-b&plan_id=plan-a"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 401
          }
        end
      )

      assert_raise ExChargebee.UnauthorizedError, fn ->
        subject()
      end
    end

    test "not found" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscriptions"

          assert URI.decode(data) == "addons[id][0]=addon-a&addons[id][1]=addon-b&plan_id=plan-a"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 404
          }
        end
      )

      assert_raise ExChargebee.NotFoundError, fn ->
        subject()
      end
    end

    test "incorrect data" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscriptions"

          assert URI.decode(data) == "addons[id][0]=addon-a&addons[id][1]=addon-b&plan_id=plan-a"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 400,
            body: '{"message": "Unknown"}'
          }
        end
      )

      assert_raise ExChargebee.InvalidRequestError, fn ->
        subject()
      end
    end

    test "correct data" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscriptions"

          assert URI.decode(data) == "addons[id][0]=addon-a&addons[id][1]=addon-b&plan_id=plan-a"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"subscription": {"id": "sub-a"}}'
          }
        end
      )

      assert subject() == %{"id" => "sub-a"}
    end
  end

  describe "post_operations" do
    post_operations = [
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
    ]

    Enum.map(post_operations, fn operation ->
      test "#{operation}" do
        operation = unquote(operation)
        mock_post(operation, "sub-a")
        assert apply(ExChargebee.Subscription, operation, ["sub-a", %{}])
      end
    end)
  end

  describe "get_operations" do
    get_operations = [:contract_terms, :discounts, :retrieve_with_scheduled_changes]

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
