# ExChargebee


Elixir implementation of the [Chargebee API](https://apidocs.chargebee.com/docs/api). 

ExChargebee is a fork of [ChargebeeElixir](https://github.com/NicolasMarlier/chargebee-elixir) by Nicolas Marlier

## Installation
The package can be installed by adding `ex_chargebee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_chargebee, "~> 0.2.3"}
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
