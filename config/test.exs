import Config

config :ex_chargebee,
  namespace: "test-namespace",
  api_key: "test_chargeebee_api_key",
  http_client: ExChargebee.HTTPoisonMock
