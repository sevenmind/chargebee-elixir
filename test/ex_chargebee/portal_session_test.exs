defmodule ExChargebee.PortalSessionTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  describe "create" do
    test "incorrect auth" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url == "https://test-namespace.chargebee.com/api/v2/portal_sessions"
          assert data == ""

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
        ExChargebee.PortalSession.create(%{})
      end
    end

    test "incorrect data" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url == "https://test-namespace.chargebee.com/api/v2/portal_sessions"
          assert data == ""

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
        ExChargebee.PortalSession.create(%{})
      end
    end

    test "correct data" do
      expect(
        ExChargebee.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url == "https://test-namespace.chargebee.com/api/v2/portal_sessions"

          assert URI.decode(data) ==
                   "customer[id]=cus_1234&redirect_url=https://redirect.com"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"portal_session": {"url": "https://doe.com"}}'
          }
        end
      )

      assert ExChargebee.PortalSession.create(%{
               redirect_url: "https://redirect.com",
               customer: %{
                 id: "cus_1234"
               }
             }) == %{"url" => "https://doe.com"}
    end
  end
end
