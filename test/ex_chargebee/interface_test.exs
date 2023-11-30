defmodule ExChargebee.InterfaceTest do
  use ExUnit.Case
  alias ExChargebee.Interface
  import Mox

  describe "get/3" do
    test "handles complex parameters" do
      expect(
        ExChargebee.HTTPoisonMock,
        :get!,
        fn url, _headers ->
          assert URI.decode(url) ==
                   "https://test-namespace.chargebee.com/api/v2/item_prices?channel[is]=web&name[is]=de.7mind.customer.annual"

          %{
            status_code: 200,
            body: ~S'{"list": []}'
          }
        end
      )

      assert %{"list" => []} =
               Interface.get(
                 "/item_prices",
                 %{channel: %{is: "web"}, name: %{is: "de.7mind.customer.annual"}}
               )
    end
  end
end
