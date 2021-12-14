defmodule ViaUtils.Configuration.CustomPutTest do
  use ExUnit.Case
  require Logger

  setup do
    ViaUtils.Helper.Test.prepare_test()
    {:ok, []}
  end

  # test "Put_in Map or Keyword" do
  #   key_type_values = [{[{:a, Map}, {:b, Keyword}, {:c, Map}], 0}, {[:b, Keyword], 10}]
  #   acc = ViaUtils.Configuration.put_in([], key_type_values)
  #   Logger.debug(inspect(acc))
  #   Process.sleep(100)
  # end

  test "Pop all the way up" do
    enum = [a: %{bb: [ccc: 10, ddd: 10]}, b: [dd: 15], c: %{xx: [1, 2, 3]}]
    key_path_with_types = ViaUtils.Configuration.get_deepest_key_path_with_type(enum)
    Logger.debug("kp with type: #{inspect(key_path_with_types)}")
    key_path = Keyword.keys(key_path_with_types)
    Logger.debug("kp: #{inspect(key_path)}")
    # {value, enum} = pop_in(enum, key_path)
    # Logger.debug("enum after pop: #{inspect(enum)}")

    {value, rem_enum} = ViaUtils.Configuration.pop_all_the_way_up(enum, key_path)
    Logger.debug("value/rem enum: #{inspect(value)}/#{inspect(rem_enum)}")
    assert value == 10
    Process.sleep(100)
  end

  test "Get key with type" do
    enum = [a: %{bb: [ccc: 10]}, b: [1, 2, 3], c: [xx: 1, yy: %{xxx: -10}]]
    # keys_with_type = ViaUtils.Configuration.get_deepest_key_path_with_type(enum)
    # Logger.warn("keys with type: #{inspect(keys_with_type)}")
    # Logger.warn("keys: #{inspect(Keyword.keys(keys_with_type))}")

    # con = ViaUtils.Configuration.put_in_with_value(keys_with_type)
    # Logger.debug("con: #{inspect(con)}")
    # assert con == enum

    nested_key_values = ViaUtils.Configuration.get_all_nested_key_values_with_type(enum)
    Logger.warn("nested_key_values: #{inspect(nested_key_values)}")

    assert nested_key_values == [
             [a: Map, bb: Keyword, ccc: 10],
             [b: [1, 2, 3]],
             [c: Keyword, xx: 1],
             [c: Keyword, yy: Map, xxx: -10]
           ]

    Process.sleep(100)
  end

  test "Put in with value" do
    enum = [a: %{bb: [ccc: 10, ddd: 10]}, b: [dd: 15], c: %{xx: [1, 2, 3]}]
    keys_with_type = ViaUtils.Configuration.get_deepest_key_path_with_type(enum)
    Logger.warn("keys with type: #{inspect(keys_with_type)}")
    new_enum = ViaUtils.Configuration.put_in_with_value(keys_with_type)
    Logger.debug("new #{inspect(new_enum)}")
    # nested_key_values = ViaUtils.Configuration.get_all_nested_key_values_with_type(enum)
    # Logger.warn("nested_key_values: #{inspect(nested_key_values)}")
    # new_enum = ViaUtils.Configuration.put_in_with_value(nested_key_values)
    Process.sleep(100)
  end

  test "Merge configs" do
    c1 = [a: %{bb: [ccc: 10, ddd: 10]}, b: [dd: 15], c: %{xx: [1, 2, 3]}]
    c2 = [a: %{1234 => :hi, bb: [ccc: 15, eee: -10]}, b: [aa: 10, bb: 11], d: [4, 5, 6], e: 10]

    new_config = ViaUtils.Configuration.merge_configuration_files(c1, c2)
    Logger.debug("new c: #{inspect(new_config)}")

    assert new_config[:a] == %{bb: [eee: -10, ccc: 15, ddd: 10]}
    assert new_config[:b] == [bb: 11, aa: 10, dd: 15]
    assert new_config[:c] == %{xx: [1, 2, 3]}
    assert new_config[:d] == [4, 5, 6]
    assert new_config[:e] == 10

    Process.sleep(100)
  end
end
