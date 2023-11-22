defmodule ExChargebee.HostedPageTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  describe "checkout_new_for_items" do
    test "correct data" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/hosted_pages/checkout_new_for_items"

          assert URI.decode(data) ==
                   "addons[id][0]=addon-a&addons[id][1]=addon-b&subscription[plan_id]=plan-a"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"hosted_page": {"url": "https://doe.com"}}'
          }
        end
      )

      assert ExChargebee.HostedPage.checkout_new_for_items(%{
               subscription: %{
                 plan_id: "plan-a"
               },
               addons: [
                 %{id: "addon-a"},
                 %{id: "addon-b"}
               ]
             }) == %{"url" => "https://doe.com"}
    end
  end

  describe "checkout_existing_for_items" do
    test "correct data" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/hosted_pages/checkout_existing_for_items"

          assert URI.decode(data) ==
                   "addons[id][0]=addon-a&addons[id][1]=addon-b&customer[id]=cus-a&subscription[id]=subscription-a&subscription[plan_id]=plan-a"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"hosted_page": {"url": "https://doe.com"}}'
          }
        end
      )

      assert ExChargebee.HostedPage.checkout_existing_for_items(%{
               subscription: %{
                 id: "subscription-a",
                 plan_id: "plan-a"
               },
               customer: %{
                 id: "cus-a"
               },
               addons: [
                 %{id: "addon-a"},
                 %{id: "addon-b"}
               ]
             }) == %{"url" => "https://doe.com"}
    end
  end
end
