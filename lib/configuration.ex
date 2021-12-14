defmodule ViaUtils.Configuration do
  require Logger

  def merge_configuration_files(default_conf, new_conf) do
    keys_with_types_all =
      if is_empty?(new_conf) do
        []
      else
        get_all_nested_key_values_with_type(new_conf)
      end

    Logger.debug("#{__MODULE__} new config: #{inspect(new_conf)}")

    Enum.reduce(keys_with_types_all, default_conf, fn keys_with_types, acc ->
      Logger.info("new keys/types #{inspect(keys_with_types)}")
      # last_value = get_in(acc, last_key)
      ViaUtils.Configuration.put_in_with_value(keys_with_types, [], acc)
      # Logger.debug("usable key: #{inspect(usable_key)}")
      # put_in(acc, usable_key, new_value)
    end)
  end

  def get_all_nested_key_values_with_type(enum, key_values \\ []) do
    nested_key_type = get_deepest_key_path_with_type(enum)
    nested_key = nested_key_type |> Keyword.keys()
    {nested_value, remaining_enum} = pop_all_the_way_up(enum, nested_key)
    Logger.warn("nested value: #{inspect(nested_value)}")

    {remaining_enum, key_values} = {remaining_enum, [nested_key_type | key_values]}

    Logger.info("rem enum: #{inspect(remaining_enum)}")
    Logger.info("key_values: #{inspect(key_values)}")

    if Enum.empty?(remaining_enum) do
      key_values = Enum.sort(key_values)
      Logger.debug("key_values: #{inspect(key_values)}")
      key_values
    else
      get_all_nested_key_values_with_type(remaining_enum, key_values)
    end
  end

  def get_deepest_key_path_with_type(enum, path \\ []) do
    first_item = Enum.take(enum, 1)
    Logger.debug("First item: #{inspect(first_item)}")

    {[first_key], first_value} =
      if is_enum?(first_item) do
        Logger.debug("is enum")
        Enum.unzip(first_item)
      else
        {[], first_item}
      end

    Logger.debug("First value(all): #{inspect(first_value)}")
    first_value = Enum.at(first_value, 0)

    value_to_store =
      cond do
        is_map(first_value) -> Map
        Keyword.keyword?(first_value) -> Keyword
        true -> first_value
      end

    Logger.debug("first key/value: #{inspect(first_key)}/#{inspect(value_to_store)}")
    path = path ++ [{first_key, value_to_store}]
    Logger.debug("path: #{inspect(path)}")

    if value_to_store == Map or value_to_store == Keyword do
      get_deepest_key_path_with_type(first_value, path)
    else
      # Logger.warn("found path: #{inspect(path)}")
      path
    end
  end

  def is_enum?(value) do
    Keyword.keyword?(value) or is_map(value) or is_tuple(value)
  end

  def is_empty?(value) do
    value == [] or value == %{}
  end

  def get_first_matching_key(enum, whole_key) do
    if is_nil(get_in(enum, whole_key)) do
      {remaining_key, dropped_key} = Enum.split(whole_key, -1)

      if Enum.empty?(remaining_key) do
        dropped_key
      else
        get_first_matching_key(enum, remaining_key)
      end
    else
      whole_key
    end
  end

  def put_in_with_value(keys_types, keys_used \\ [], enum \\ [], type_prev \\ Keyword) do
    {[key_type], remaining_keys_types} = Enum.split(keys_types, 1)
    {key, type} = key_type

    Logger.debug("key/type/type_prev: #{key}/#{type}/#{type_prev}")
    Logger.debug("remaining: #{inspect(remaining_keys_types)}")
    Logger.debug("keys used: #{inspect(keys_used)}")

    local_enum =
      if keys_used == [] do
        enum
      else
        get_in(enum, keys_used)
      end

    Logger.debug("local enum0: #{inspect(local_enum)}")

    local_enum =
      cond do
        Enum.empty?(remaining_keys_types) ->
          apply(type_prev, :put, [local_enum, key, type])

        type == Map ->
          apply(type_prev, :put_new, [local_enum, key, %{}])

        type == Keyword ->
          apply(type_prev, :put_new, [local_enum, key, []])
      end

    Logger.debug("local enum1: #{inspect(local_enum)}")

    enum =
      if keys_used == [] do
        local_enum
      else
        put_in(enum, keys_used, local_enum)
      end

    Logger.debug("enum: #{inspect(enum)}")

    keys_used = keys_used ++ [key]

    if Enum.empty?(remaining_keys_types) do
      enum
    else
      put_in_with_value(remaining_keys_types, keys_used, enum, type)
    end
  end

  def pop_all_the_way_up(enum, key_path, value \\ nil) do
    Logger.info("kp/value: #{inspect(key_path)}/#{inspect(get_in(enum, key_path))}")

    if !is_empty?(get_in(enum, key_path)) and !is_nil(value) do
      {value, enum}
    else
      {temp_value, enum} = pop_in(enum, key_path)
      key_path = List.delete_at(key_path, -1)
      Logger.debug("Value popped/new path: #{inspect(temp_value)}/#{inspect(key_path)}")
      value = if is_nil(value), do: temp_value, else: value

      if key_path == [] do
        {value, enum}
      else
        pop_all_the_way_up(enum, key_path, value)
      end
    end
  end

  def extract_key_path_from_keys_types(key_path_with_type) do
    Enum.unzip(key_path_with_type) |> elem(0)
  end
end
