defmodule ExChargebee.Interface.ParameterSerializer do
  @moduledoc """
  A custom serializer for Chargebee API get and post parameters
  
  Behavior resembles x-www-form-urlencoded at first glance, but diverges sharply
  in handling of nested arrays and maps.
  """
  # serialize/3 is a 1:1 adaptation of Chargebee-Ruby `Chargebee::Util.serialize/3`
  # from https://github.com/chargebee/chargebee-ruby/blob/42f4aa5e58d5760d9f66d3aff02f8389faa6e68f/lib/chargebee/util.rb#L5
  def serialize(value, prefix \\ nil, index \\ nil)

  def serialize(value, prefix, index) when is_map(value) do
    value
    |> Enum.flat_map(&do_serialize(&1, prefix, index))
    |> Map.new()
  end

  def serialize(value, prefix, nil) when is_list(value) do
    value
    |> Enum.with_index()
    |> Enum.flat_map(fn {item, i} -> serialize(item, prefix, i) end)
    |> Map.new()
  end

  # Apparently Second Degree nested arrays are just encoded as json values
  def serialize(value, prefix, index) when is_list(value) do
    value = Jason.encode!(value)

    key = "#{prefix}[#{index}]"

    [{key, value}]
  end

  def serialize(_value, nil, nil) do
    raise ArgumentError, "Only hash or arrays are allowed as value"
  end

  def serialize(value, prefix, index) do
    [{prefix(index, prefix), value}]
  end

  def do_serialize({_k, nil}, _prefix, _index), do: []

  def do_serialize({k, v}, _prefix, _index) when k in ["metadata", :metadata] and is_map(v),
    do: [{as_string(k), Jason.encode!(v)}]

  def do_serialize({k, v}, prefix, index)
      when k in ["in", :in, :not_in, "not_in", "between", :between] and is_list(v) do
    value = v |> Enum.map(&as_string/1) |> Enum.intersperse(",")

    pre = if is_nil(prefix), do: as_string(k), else: "#{prefix}[#{k}]"

    do_serialize("[#{value}]", pre, index)
  end

  def do_serialize({k, %struct{} = v}, prefix, index)
      when struct in [Date, DateTime, NaiveDateTime] do
    do_serialize(as_string(v), prefix(k, prefix), index)
  end

  def do_serialize({k, v}, prefix, index) when is_map(v) or is_list(v) do
    pre = if is_nil(prefix), do: as_string(k), else: "#{prefix}[#{k}]"

    serialize(v, pre, index)
  end

  def do_serialize({k, v}, prefix, index) do
    do_serialize(v, prefix(k, prefix), index)
  end

  def do_serialize(value, prefix, nil) do
    [{as_string(prefix), as_string(value)}]
  end

  def do_serialize(value, prefix, index) do
    prefix = "#{prefix}[#{index}]"

    do_serialize(value, prefix, nil)
  end

  defp date_to_unix(%DateTime{} = dt), do: DateTime.to_unix(dt)

  defp date_to_unix(%NaiveDateTime{} = dt),
    do: dt |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()

  defp date_to_unix(%Date{} = dt),
    do: dt |> DateTime.new!(~T[00:00:00], "Etc/UTC") |> DateTime.to_unix()

  # as_string is a helper to convert datelike objects into unix timestamps
  defp as_string(%struct{} = v) when struct in [Date, DateTime, NaiveDateTime] do
    date_to_unix(v) |> to_string()
  end

  defp as_string(v), do: to_string(v)

  defp prefix(key, nil), do: to_string(key)
  defp prefix(key, prefix), do: "#{prefix}[#{key}]"
end
