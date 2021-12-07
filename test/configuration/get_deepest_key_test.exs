defmodule ViaUtils.Configuration.GetDeepestKeyTest do
  use ExUnit.Case
  require Logger

  setup do
    ViaUtils.Helper.Test.prepare_test()
    {:ok, []}
  end

  test "Get key" do
    conf = [a: [x: %{alpha: 1, beta: 2}, y: 4], b: [u: 1, v: 2, w: 2, z: %{foo: 100, bar: -100}]]

    first_deepest_key_path = ViaUtils.Configuration.get_deepest_key_path(conf)
    # Logger.debug("1st path: #{inspect(first_deepest_key_path)}")
    assert first_deepest_key_path == [:a, :x, :alpha]

    {first_value, _remaining_conf} = pop_in(conf, first_deepest_key_path)
    assert first_value == 1

    Process.sleep(100)
  end

  test "Update conf" do
    default_conf = [
      a: [x: %{beta: 2, alpha: 1}, y: 4, z: [5]],
      b: [z: %{foo: 100, bar: -100}, u: 1, v: 2, w: 2]
    ]

    # default_conf = [
    #   a: [w: %{b: 1, c: -1}, x: [5], y: 4, z: []]
    # ]

    nested_key_values = ViaUtils.Configuration.get_all_nested_key_values(default_conf)
    Logger.info("nested kvs: #{inspect(nested_key_values)}")

    new_conf = [a: [x: %{alpha: 2}, z: []], b: [u: 3, z: %{foo: -200}]]
    # new_conf = [a: [w: %{b: 0}, x: [1, 2, 3]]]
    merged_conf = ViaUtils.Configuration.merge_configuration_files(default_conf, new_conf)
    Logger.debug("merged conf: #{inspect(merged_conf)}")
    assert get_in(merged_conf, [:a, :x, :alpha]) == 2
    assert get_in(merged_conf, [:b, :u]) == 3
    assert get_in(merged_conf, [:b, :z, :foo]) == -200
    assert get_in(merged_conf, [:b, :v]) == 2
    assert get_in(merged_conf, [:a, :z]) == []
    Process.sleep(100)
  end

  test "Identical configs" do
    default_conf = [
      a: [x: %{beta: 2, alpha: 1}, y: 4, z: [5]],
      b: [z: %{foo: 100, bar: -100}, u: 1, v: 2, w: 2]
    ]

    new_conf = [
      a: [x: %{beta: 2, alpha: 1}, y: 4, z: [5]],
      b: [z: %{foo: 100, bar: -100}, u: 1, v: 2, w: 2]
    ]

    merged_conf = ViaUtils.Configuration.merge_configuration_files(default_conf, new_conf)
    Logger.debug("merged conf: #{inspect(merged_conf)}")
    assert merged_conf == default_conf
    Process.sleep(100)
  end

  test "Empty new config" do
    default_conf = [
      a: [x: %{beta: 2, alpha: 1}, y: 4, z: [5]],
      b: [z: %{foo: 100, bar: -100}, u: 1, v: 2, w: 2]
    ]

    new_conf = []

    merged_conf = ViaUtils.Configuration.merge_configuration_files(default_conf, new_conf)
    Logger.debug("merged conf: #{inspect(merged_conf)}")
    assert merged_conf == default_conf
    Process.sleep(100)
  end

  test "Put_in value with no existing key " do
    default_conf = [a: %{x: 0}, b: []]
    new_conf = [a: %{y: 0}, b: [c: [1, 2, 3]]]

    matching_key = ViaUtils.Configuration.get_first_matching_key(default_conf, [:b, :c])
    assert matching_key == [:b]

    merged_conf = ViaUtils.Configuration.merge_configuration_files(default_conf, new_conf)
    Logger.debug("merged conf: #{inspect(merged_conf)}")
    assert merged_conf[:a][:y] == 0
    assert merged_conf[:b][:c] == [1, 2, 3]
    Process.sleep(100)
  end
end
