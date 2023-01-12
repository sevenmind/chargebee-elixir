# ExChargebee


Elixir implementation of [Chargebee API](https://apidocs.chargebee.com/docs/api).

ExChargebee is a fork of [ChargebeeElixir](https://github.com/NicolasMarlier/chargebee-elixir) by Nicolas Marlier

## v0.2.0
This is a work in progress: right now, we only implement those methods:
- list
- retrieve
- create
- update

on those resources:
- addon
- coupon_code
- coupon_set
- customer
- event
- gift
- hosted_page
- invoice
- item_family
- item_price
- item
- payment_intent
- payment_source
- plan
- portal_session
- subscription

## Installation
The package can be installed by adding `ex_chargebee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_chargebee, "~> 0.2.2"}
  ]
end
```

## Configuration
```elixir
# config/dev.ex
config :ex_chargebee,
  namespace: "$your_namespace",
  api_key: "$your_api_key"
```

## Usage
```elixir
# e.g.
ExChargebee.Plan.list()
```
