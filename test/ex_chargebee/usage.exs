defmodule ExChargebee.UsageTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  describe "list_usages" do
    test "returns a list of usages" do
      expect(
        ExChargebee.HTTPoisonMock,
        :get!,
        fn url, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/usages"

          %{
            status_code: 200,
            body: ~S'{"list": [{"usage": {"id": "sub-a"}}]}'
          }
        end
      )

      assert ExChargebee.Usage.list() == [%{"id" => "sub-a"}]
    end
  end
end
