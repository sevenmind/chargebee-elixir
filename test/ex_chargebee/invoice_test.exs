defmodule ExChargebee.InvoiceTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  def subject do
    ExChargebee.Invoice.close(
      "draft_inv_abcde",
      %{
        "invoice_note" => "This is a note"
      }
    )
  end

  describe "close" do
    test "incorrect auth" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

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
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

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
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

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
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"invoice": {"id": "abcde"}}'
          }
        end
      )

      assert subject() == %{"id" => "abcde"}
    end
  end

  describe "Invoice.list_root_operations" do
    post_operations = ExChargebee.Invoice.operations()[:list_root_operations]

    Enum.map(post_operations, fn operation ->
      test "Invoice.#{operation}" do
        operation = unquote(operation)
        mock_list_root(operation)
        assert apply(ExChargebee.Invoice, operation, [%{}])
      end
    end)
  end

  describe "Invoice.list_operations" do
    operaations = ExChargebee.Invoice.operations()[:list_operations]

    Enum.map(operaations, fn operation ->
      test "Invoice.#{operation}" do
        operation = unquote(operation)
        mock_list(operation, "sub-a")
        assert apply(ExChargebee.Invoice, operation, ["sub-a", %{}])
      end
    end)
  end

  describe "post_root_operations" do
    post_operations = ExChargebee.Invoice.operations()[:post_root_operations]

    Enum.map(post_operations, fn operation ->
      test "Invoice.#{operation}" do
        operation = unquote(operation)
        mock_post_root(operation)
        assert apply(ExChargebee.Invoice, operation, [%{}])
      end
    end)
  end

  describe "post_operations" do
    post_operations = ExChargebee.Invoice.operations()[:post_operations]

    Enum.map(post_operations, fn
      {type, operation} ->
        test "Invoice.#{operation} returns #{type}" do
          operation = unquote(operation)
          mock_post(operation, "inv-a", unquote(type))
          assert apply(ExChargebee.Invoice, operation, ["inv-a", %{}])
        end

      operation ->
        test "Invoice.#{operation}" do
          operation = unquote(operation)
          mock_post(operation, "inv-a")
          assert apply(ExChargebee.Invoice, operation, ["inv-a", %{}])
        end
    end)
  end

  describe "get_operations" do
    post_operations = ExChargebee.Invoice.operations()[:get_operations]

    Enum.map(post_operations, fn
      {type, operation} ->
        test "Invoice.#{operation} returns #{type}" do
          operation = unquote(operation)
          mock_get(operation, "inv-a", unquote(type))
          assert apply(ExChargebee.Invoice, operation, ["inv-a", %{}])
        end

      operation ->
        test "Invoice.#{operation}" do
          operation = unquote(operation)
          mock_get(operation, "inv-a")
          assert apply(ExChargebee.Invoice, operation, ["inv-a", %{}])
        end
    end)

    test "download_einvoice" do
      id = "some_id"

      expect(
        ExChargebee.HTTPoisonMock,
        :get!,
        fn url, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/invoices/#{id}/download_einvoice"

          %{
            status_code: 200,
            body:
              Jason.encode!(%{
                "downloads" => [
                  %{
                    "download_url" => "sub-a"
                  }
                ]
              })
          }
        end
      )

      assert [
               %{
                 "download_url" => "sub-a"
               }
             ] == ExChargebee.Invoice.download_einvoice(id)
    end
  end

  def mock_list_root(operation) do
    resource = Inflex.singularize(operation)
    resource_name = String.replace_prefix(to_string(operation), "list_", "")

    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/invoices/#{resource_name}"

        %{
          status_code: 200,
          body:
            Jason.encode!(%{
              "list" => [
                %{
                  resource => %{
                    "id" => "sub-a"
                  }
                }
              ]
            })
        }
      end
    )
  end

  def mock_list(operation, id) do
    resource_name = String.replace_prefix(to_string(operation), "list_", "")

    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/invoices/#{id}/#{resource_name}"

        %{
          status_code: 200,
          body:
            Jason.encode!(%{
              "list" => [
                %{
                  "invoice" => %{
                    "id" => "sub-a"
                  }
                }
              ]
            })
        }
      end
    )
  end

  def mock_post(operation, id, type \\ "invoice") do
    expect(
      ExChargebee.HTTPoisonMock,
      :post!,
      fn url, _body, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/invoices/#{id}/#{operation}"

        %{
          status_code: 200,
          body:
            Jason.encode!(%{
              type => %{
                "id" => "sub-a"
              }
            })
        }
      end
    )
  end

  def mock_post_root(operation, resource \\ "invoice") do
    expect(
      ExChargebee.HTTPoisonMock,
      :post!,
      fn url, _body, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/invoices/#{operation}"

        %{
          status_code: 200,
          body:
            Jason.encode!(%{
              resource => %{
                "id" => "sub-a"
              }
            })
        }
      end
    )
  end

  def mock_get(operation, id, type \\ "invoice") do
    expect(
      ExChargebee.HTTPoisonMock,
      :get!,
      fn url, _headers ->
        assert url ==
                 "https://test-namespace.chargebee.com/api/v2/invoices/#{id}/#{operation}"

        %{
          status_code: 200,
          body:
            Jason.encode!(%{
              type => %{
                "id" => "sub-a"
              }
            })
        }
      end
    )
  end
end
