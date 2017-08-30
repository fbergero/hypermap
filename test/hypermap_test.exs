defmodule HyperMapTest do
  use ExUnit.Case
  doctest HyperMap

  test "fill a HyperMap and and fetch it back" do
    hypermap =
      HyperMap.new([:x, :y, :z])
      |> HyperMap.put(1, x: 1, y: 2, z: 3)
      |> HyperMap.put(2, x: 3, y: 2, z: 4)
      |> HyperMap.put(3, x: 3, y: 3, z: 5)

    assert [{_keys, 1}] = HyperMap.fetch(hypermap, x: 1)
    assert [{_keys, 3}] = HyperMap.fetch(hypermap, z: 5)
    assert [_, _] = HyperMap.fetch(hypermap, x: 3)
  end

  test "initiate the HyperMap from a list" do
    hypermap =
      HyperMap.from_list([:first_name, :last_name],
        [
          {"John", "Doe", :a},
          {"John", "Lennon", :b},
          {"Mary", "Doe", :c},
          {"Alice", "Doe", :c},
        ])

    assert [{[first_name: "Mary", last_name: "Doe"], :c}] =
      HyperMap.fetch(hypermap, first_name: "Mary")

    assert [{_keys, :c}] = HyperMap.fetch(hypermap, first_name: "Alice")
    assert [{_keys, :b}] = HyperMap.fetch(hypermap, last_name: "Lennon")
    assert [_, _, _] = HyperMap.fetch(hypermap, last_name: "Doe")
  end
end
