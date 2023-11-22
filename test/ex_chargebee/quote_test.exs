defmodule ExChargebee.QuoteTest do
  use ExUnit.Case
  import Mox
  alias ExChargebee.Quote

  test "quote_line_groups" do
    id = "some_id"

    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/quotes/#{id}/quote_line_groups"

        %{
          status_code: 200,
          body: ~S({"list": [{"quote_line_group":{"id": "ooo"}}]})
        }
      end
    )

    assert Quote.list_quote_line_groups(id) == [%{"id" => "ooo"}]
  end
end
