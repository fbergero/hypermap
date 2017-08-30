defmodule HyperMap do
  @moduledoc """
  HyperMap provides a multiple-key Map.

  A use case could be to store a phonebook from people and then
  looking it up by either their first name or their last name without
  having to do a full lookup.
  """
  defstruct [
    values: nil,
    num_keys: nil,
    opts: nil
  ]

  @doc """
  `new` creates a new HyperMap. The `keys` argument is a list defining
  the "name" of each key. It can be any term.

  For now no `opts` are allowed.

  Example: `hmap = HyperMap.new([:first_name, :last_name])`
  """
  @spec new(keys :: [term()], opts :: Keyword.t) :: map
  def new(keys, opts \\ []) do
    if length(keys) < 2, do:
      raise "inserting a value with less than 2 keys. You should use a Map"

    %__MODULE__{opts: opts,
                values: empty_values(keys),
                num_keys: length(keys)}
  end

  @doc """
  `put` adds a `value` for the given `keys` to the HyperMap.

  Example `HyperMap.put(hmap, "555-4246031", [{:first_name, "Joe"}, {:last_name, "Doe"}])`

  If the keys are atoms they can be given as a keyword
  `HyperMap.put(hmap, "555-4246031", first_name: "Joe", last_name: "Doe")`
  """
  @spec put(hypermap :: map, value :: term(), keys :: [tuple()]) :: map
  def put(%__MODULE__{} = hmap, value, keys) when is_list(keys) do
    if hmap.num_keys != length(keys), do:
      raise "inserting a value with a different number of keys " <>
            "than #{hmap.num_keys}"

    add_item = &(&1 ++ [{keys, value}])
    update_in(hmap.values,
      fn vals ->
        Enum.reduce(keys, vals,
          fn ({key, key_val}, map) ->
            unless Map.has_key?(map, key),
              do: raise "unknown key #{inspect key}"

            update_in(map, [key],
              &(Map.update(&1, key_val, [{keys, value}], add_item)))
         end)
      end)
  end

  @doc """
  `from_list` initializes a HyperMap from a list a `values` for the given
  `keys`.

  Example:
  `hypermap = HyperMap.from_list([:first_name, :last_name],
    [{"John", "Doe", "555-4246031"},
     {"Mary", "Doe", "555-4246049"}])`
  """
  @spec from_list(keys :: [term()], values :: [tuple()]) :: map
  def from_list(keys, values) when is_list(keys) and is_list(values) do
    Enum.reduce(values, __MODULE__.new(keys),
      fn (value, hmap) when is_tuple(value) ->
        unless tuple_size(value) - 1 == length(keys), do:
          raise "incompatible tuple size with keys"

        put(hmap,
            elem(value, tuple_size(value) - 1),
            List.zip([keys, value]))
      end)
  end

  @doc """
  `fetch` looks-up a value in the HyperMap using the key valued as second argument.
  To look up a value by lastname we could do: `fetch(hypermap, last_name: "Doe")`
  To look up vy first name: `fetch(hypermap, first_name: "John")`
  """
  @spec fetch(hypermap :: map, key_value :: [tuple]) :: map
  def fetch(%__MODULE__{} = hmap, [{key, key_val}]) do
    unless Map.has_key?(hmap.values, key),
      do: raise "unknown key #{inspect key}"

    hmap
    |> Map.get(:values)
    |> Map.get(key)
    |> Map.get(key_val)
  end

  defp empty_values(keys) do
    Enum.reduce(keys, %{}, &Map.put(&2, &1, %{}))
  end
end
