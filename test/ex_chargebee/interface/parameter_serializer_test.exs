defmodule ExChargebee.Interface.ParameterSerializerTest do
  use ExUnit.Case
  doctest ExChargebee.Interface.ParameterSerializer
  alias ExChargebee.Interface.ParameterSerializer

  describe "serialize" do
    test "chargebee example" do
      # from chargebee-ruby test case
      input = %{
        :id => "sub_KyVq7DNSNM7CSD",
        :plan_id => "free",
        :addons => [%{:id => "monitor", :quantity => 2}, %{:id => "ssl"}],
        :addon_ids => ["addon_one", "addon_two"],
        :card => %{
          :first_name => "Rajaraman",
          :last_name => "Santhanam",
          :number => "4111111111111111",
          :expiry_month => "1",
          :expiry_year => "2024",
          :cvv => "007"
        }
      }

      output = %{
        "id" => "sub_KyVq7DNSNM7CSD",
        "plan_id" => "free",
        "addons[id][0]" => "monitor",
        "addons[quantity][0]" => "2",
        "addons[id][1]" => "ssl",
        "addon_ids[0]" => "addon_one",
        "addon_ids[1]" => "addon_two",
        "card[first_name]" => "Rajaraman",
        "card[last_name]" => "Santhanam",
        "card[number]" => "4111111111111111",
        "card[expiry_month]" => "1",
        "card[expiry_year]" => "2024",
        "card[cvv]" => "007"
      }

      assert ParameterSerializer.serialize(input) == output
    end

    test "chargebeee example 2" do
      # From the chargebee-go Test case
      input = %{
        plan_id: "cbdemo_grow",
        customer: %{
          email: "john@user.com",
          first_name: "John",
          last_name: "Doe",
          locale: "frCA",
          phone: "+19499999999",
          auto_collection: "on"
        },
        addons: [
          %{
            id: "cbdemo_conciergesupport"
          },
          %{
            id: "cbdemo_additionaluser",
            quantity: 2
          }
        ],
        coupon_ids: ["cbdemo_earlybird"]
      }

      output = %{
        "coupon_ids[0]" => "cbdemo_earlybird",
        "customer[phone]" => "+19499999999",
        "plan_id" => "cbdemo_grow",
        "customer[last_name]" => "Doe",
        "customer[locale]" => "frCA",
        "addons[id][0]" => "cbdemo_conciergesupport",
        "addons[id][1]" => "cbdemo_additionaluser",
        "addons[quantity][1]" => "2",
        "customer[email]" => "john@user.com",
        "customer[auto_collection]" => "on",
        "customer[first_name]" => "John"
      }

      assert ParameterSerializer.serialize(input) == output
    end

    test "simple list" do
      assert ParameterSerializer.serialize([
               %{id: "object-a"},
               %{id: "object-b"}
             ]) == %{"id[0]" => "object-a", "id[1]" => "object-b"}
    end

    test "deep nesting, no lists" do
      assert ParameterSerializer.serialize(%{
               addon: %{
                 id: "addon-a",
                 nested: %{
                   object: %{
                     id: "object-a"
                   }
                 }
               }
             }) == %{"addon[id]" => "addon-a", "addon[nested][object][id]" => "object-a"}
    end

    test "simple nesting" do
      assert ParameterSerializer.serialize(%{
               addons: [
                 %{
                   id: "addon-a",
                   price: 10
                 },
                 %{
                   id: "addon-b",
                   quantity: 2
                 }
               ]
             }) == %{
               "addons[id][0]" => "addon-a",
               "addons[id][1]" => "addon-b",
               "addons[price][0]" => "10",
               "addons[quantity][1]" => "2"
             }
    end

    test "Example of complex nested list field" do
      assert ParameterSerializer.serialize(%{
               item_constraints: [
                 %{
                   constraint: "specific",
                   item_type: "plan",
                   item_price_ids: ["item_a"]
                 }
               ]
             }) == %{
               "item_constraints[constraint][0]" => "specific",
               "item_constraints[item_type][0]" => "plan",
               "item_constraints[item_price_ids][0]" => "[\"item_a\"]"
             }
    end

    test "when query encoded" do
      input = %{
        item_constraints: [
          %{
            constraint: "specific",
            item_type: "plan",
            item_price_ids: "[\"item_a\"]"
          }
        ]
      }

      as_encoded_params =
        ~s<item_constraints[constraint][0]=specific&item_constraints[item_price_ids][0]=["item_a"]&item_constraints[item_type][0]=plan>

      assert as_encoded_params ==
               input
               |> ParameterSerializer.serialize()
               |> URI.encode_query()
               |> URI.decode()
    end

    test "drops nil fields" do
      # from chargebee-ruby test case
      input = %{
        :id => "sub_KyVq7DNSNM7CSD",
        :plan_id => "free",
        :item_family_id => nil
      }

      output = %{
        "id" => "sub_KyVq7DNSNM7CSD",
        "plan_id" => "free"
      }

      assert ParameterSerializer.serialize(input) == output
    end

    test "serializes metadata as encoded json" do
      input = %{metadata: %{some: "value"}}

      output = %{"metadata" => ~S({"some":"value"})}

      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with is_not" do
      input = %{name: %{is_not: "sku"}}

      output = %{"name[is_not]" => "sku"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with not_in" do
      input = %{name: %{not_in: ["sku"]}}

      output = %{"name[not_in]" => ~S([sku])}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with is_present" do
      input = %{name: %{is_present: true}}

      output = %{"name[is_present]" => "true"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with starts_with" do
      input = %{name: %{starts_with: "sku"}}

      output = %{"name[starts_with]" => "sku"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `is`" do
    test "filter with string" do
      input = %{name: %{is: "sku"}}

      output = %{"name[is]" => "sku"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with integer" do
      input = %{quantity: %{is: 1}}

      output = %{"quantity[is]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with boolean" do
      input = %{price: %{is: true}}

      output = %{"price[is]" => "true"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `is_not`" do
    test "filter with string" do
      input = %{name: %{is_not: "sku"}}

      output = %{"name[is_not]" => "sku"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with integer" do
      input = %{quantity: %{is_not: 1}}

      output = %{"quantity[is_not]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `in`" do
    test "filter with single string" do
      input = %{name: %{in: ["sku"]}}

      output = %{"name[in]" => ~S([sku])}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with multiple strings" do
      input = %{name: %{in: ["sku", "sku2"]}}

      output = %{"name[in]" => ~S([sku,sku2])}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `not_in`" do
    test "filter with single string" do
      input = %{name: %{not_in: ["sku"]}}

      output = %{"name[not_in]" => ~S([sku])}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with multiple strings" do
      input = %{name: %{not_in: ["sku", "sku2"]}}

      output = %{"name[not_in]" => ~S([sku,sku2])}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `is_present`" do
    test "filter with true" do
      input = %{name: %{is_present: true}}

      output = %{"name[is_present]" => "true"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with false" do
      input = %{name: %{is_present: false}}

      output = %{"name[is_present]" => "false"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `starts_with`" do
    test "filter with string" do
      input = %{name: %{starts_with: "sku"}}

      output = %{"name[starts_with]" => "sku"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `gt`" do
    test "filter with integer" do
      input = %{quantity: %{gt: 1}}

      output = %{"quantity[gt]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `gte`" do
    test "filter with integer" do
      input = %{quantity: %{gte: 1}}

      output = %{"quantity[gte]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `lt`" do
    test "filter with integer" do
      input = %{quantity: %{lt: 1}}

      output = %{"quantity[lt]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `lte`" do
    test "filter with integer" do
      input = %{quantity: %{lte: 1}}

      output = %{"quantity[lte]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `between`" do
    test "filter with integer" do
      input = %{quantity: %{between: [1, 2]}}

      output = %{"quantity[between]" => ~S([1,2])}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with DateTimes" do
      input = %{created_at: %{between: [~U[2021-01-01 00:00:00Z], ~U[2021-01-02 00:00:00Z]]}}

      output = %{"created_at[between]" => ~S([1609459200,1609545600])}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `after`" do
    test "filter with integer" do
      input = %{quantity: %{after: 1}}

      output = %{"quantity[after]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with DateTime" do
      input = %{created_at: %{after: ~U[2021-01-01 00:00:00Z]}}

      output = %{"created_at[after]" => "1609459200"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `before`" do
    test "filter with integer" do
      input = %{quantity: %{before: 1}}

      output = %{"quantity[before]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with DateTime" do
      input = %{created_at: %{after: ~U[2021-01-01 00:00:00Z]}}

      output = %{"created_at[after]" => "1609459200"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  describe "Filter `on`" do
    test "filter with integer" do
      input = %{quantity: %{on: 1}}

      output = %{"quantity[on]" => "1"}
      assert ParameterSerializer.serialize(input) == output
    end

    test "filter with datetime" do
      input = %{created_at: %{on: ~U[2021-01-01 00:00:00Z]}}
      output = %{"created_at[on]" => "1609459200"}
      assert ParameterSerializer.serialize(input) == output
    end
  end

  test "filter `on`" do
    input = %{created_at: %{on: ~U[2021-01-01 00:00:00Z]}}

    output = %{"created_at[on]" => "1609459200"}
    assert ParameterSerializer.serialize(input) == output
  end
end
