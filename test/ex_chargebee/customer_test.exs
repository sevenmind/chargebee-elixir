defmodule ExChargebee.CustomerTest do
  use ExUnit.Case
  alias ExChargebee.Customer
  import Mox

  setup :verify_on_exit!

  def subject do
    ExChargebee.Customer.subscription_for_items(
      "cus_1",
      %{
        subscription_items: %{
          item_price_id: ["basic-USD", "day-pass-USD"],
          billing_cycles: [2],
          quantity: [1],
          unit_price: [100]
        }
      }
    )
  end

  describe "subscription_for_items" do
    test "incorrect auth" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, _data, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscription_for_items"

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
        fn url, _data, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscription_for_items"

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
        fn url, _data, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscription_for_items"

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
                   "https://test-namespace.chargebee.com/api/v2/customers/cus_1/subscription_for_items"

          assert URI.decode(data) ==
                   "subscription_items[billing_cycles][0]=2&subscription_items[item_price_id][0]=basic-USD&subscription_items[item_price_id][1]=day-pass-USD&subscription_items[quantity][0]=1&subscription_items[unit_price][0]=100"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"customer": {"id": "sub-a"}}'
          }
        end
      )

      assert subject() == %{"id" => "sub-a"}
    end
  end

  describe "post_operations" do
    post_operations = Customer.operations(:post_operations)

    Enum.map(post_operations, fn operation ->
      test "#{operation}" do
        operation = unquote(operation)
        mock_post(operation, "cus_1")
        assert apply(ExChargebee.Customer, operation, ["cus_1", %{}, []])
      end
    end)
  end

  describe "get_operations" do
    get_operations = Customer.operations(:get_operations)

    Enum.map(get_operations, fn operation ->
      test "#{operation}" do
        operation = unquote(operation)
        mock_get(operation, "cus_1")
        assert apply(ExChargebee.Customer, operation, ["cus_1", %{}, []])
      end
    end)
  end

  test "get hierarchy" do
    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/customers/cus_1/hierarchy"

        %{
          status_code: 200,
          body: ~S'{"hierarchies": [{"id": "sub-a"}]}'
        }
      end
    )

    assert Customer.hierarchy("cus_1", %{}, []) == [%{"id" => "sub-a"}]
  end

  test "list_contacts" do
    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/customers/cus_1/contacts"

        %{
          status_code: 200,
          body: ~S'{"list": [{"contact":{"id": "sub-a"}}]}'
        }
      end
    )

    assert Customer.list_contacts("cus_1", %{}, []) == [%{"id" => "sub-a"}]
  end

  test "list_payment_voucher" do
    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/customers/cus_1/payment_vouchers"

        %{
          status_code: 200,
          body: ~S'{"list": [{"payment_voucher":{"id": "sub-a"}}]}'
        }
      end
    )

    assert Customer.list_payment_vouchers("cus_1", %{}, []) == [%{"id" => "sub-a"}]
  end

  def mock_post(operation, id) do
    expect(
      ExChargebee.HTTPoisonMock,
      :post!,
      fn url, _data, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/customers" <>
                   "/" <> id <> "/" <> to_string(operation)

        %{
          status_code: 200,
          body: '{"customer": {"id": "sub-a"}}'
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
                 "https://test-namespace.chargebee.com/api/v2/customers/#{id}/#{operation}"

        %{
          status_code: 200,
          body: '{"customer": {"id": "sub-a"}}'
        }
      end
    )
  end
end
