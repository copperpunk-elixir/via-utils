defmodule ViaUtils.Configuration do
  require Logger

  def merge_configuration_files(default_conf, new_conf) do
    nested_key_values =
      if is_empty?(new_conf) do
        []
      else
        get_all_nested_key_values(new_conf)
      end

    Logger.debug("#{__MODULE__} new config: #{inspect(new_conf)}")

    Enum.reduce(nested_key_values, default_conf, fn {new_key, new_value}, acc ->
      Logger.info("new k/v: #{inspect(new_key)}/#{inspect(new_value)}")
      usable_key = get_first_matching_key(acc, new_key)
      usable_value = get_in(acc, usable_key)
      # last_key = Enum.take(usable_key, max(length(usable_key)-1,1))
      Logger.debug("usable key: #{inspect(usable_key)}")
      last_key =
        (new_key -- usable_key)
        |> Enum.at(0,usable_key)

      # last_value = get_in(acc, last_key)
      Logger.debug("usable value/last key: #{inspect(usable_value)}/#{inspect(last_key)}")
      last_value =
        cond do
        is_map(usable_value) ->
          Logger.warn("map")
          Map.put(usable_value, last_key, new_value)
        Keyword.keyword?(usable_value) ->
          Logger.warn("list")
          Keyword.put(usable_value, last_key, new_value)
        true ->
          new_value
        end

      Logger.debug("last k/v: #{inspect(last_key)}/#{inspect(last_value)}")
      put_in(acc, usable_key, last_value)
      # Logger.debug("usable key: #{inspect(usable_key)}")
      # put_in(acc, usable_key, new_value)
    end)
  end

  def get_all_nested_key_values(enum, key_values \\ []) do
    nested_key = get_deepest_key_path(enum)
    {nested_value, remaining_enum} = pop_in(enum, nested_key)
    # Logger.warn("nested value: #{inspect(nested_value)}")

    key_one_level_up = List.delete_at(nested_key, -1)
    # Logger.debug("key one up: #{inspect(key_one_level_up)}")

    {remaining_enum, key_values} =
      if is_empty?(get_value_one_level_up(remaining_enum, key_one_level_up)) do
        if key_one_level_up == [] do
          {_, rem_enum} = pop_in(remaining_enum, nested_key)
          # Logger.debug("KOU empty. Pop nested value")
          {rem_enum, key_values}
        else
          {_, rem_enum} = pop_in(remaining_enum, key_one_level_up)
          # Logger.debug("v @ kou empty")
          {rem_enum, [{nested_key, nested_value} | key_values]}
        end
      else
        {remaining_enum, [{nested_key, nested_value} | key_values]}
      end

    # Logger.info("rem enum: #{inspect(remaining_enum)}")

    # key_values = [{nested_key, nested_value} | key_values]

    # if nested_value == [] or nested_value == %{} do
    #   key_values
    # else
    # [{nested_key, nested_value} | key_values]
    # end

    Logger.debug("key_values: #{inspect(key_values)}")

    if Enum.empty?(remaining_enum) do
      key_values
    else
      get_all_nested_key_values(remaining_enum, key_values)
    end
  end

  def get_deepest_key_path(enum, path \\ []) do
    first_item = Enum.take(enum, 1)
    # Logger.debug("First item: #{inspect(first_item)}")

    {first_key, first_value} =
      if is_enum?(first_item) do
        Enum.unzip(first_item)
      else
        {[], first_item}
      end

    # Logger.debug("First value(all): #{inspect(first_value)}")
    first_value = Enum.at(first_value, 0)
    # Logger.debug("first key/value: #{inspect(first_key)}/#{inspect(first_value)}")
    path = path ++ first_key
    # Logger.debug("path: #{inspect(path)}")

    if is_enum?(first_value) do
      get_deepest_key_path(first_value, path)
    else
      # Logger.warn("found path: #{inspect(path)}")
      path
    end
  end

  def get_value_one_level_up(enum, key_one_level_up) do
    if key_one_level_up == [] do
      # Logger.debug("KOU empty")
      []
    else
      # Logger.debug("v @ KOU: #{inspect(get_in(enum, key_one_level_up))}")
      get_in(enum, key_one_level_up)
    end
  end

  def is_enum?(value) do
    Keyword.keyword?(value) or is_map(value)
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
end
