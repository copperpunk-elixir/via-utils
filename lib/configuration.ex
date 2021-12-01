defmodule ViaUtils.Configuration do
  require Logger

  def merge_configuration_files(default_conf, new_conf) do
    nested_key_values = get_all_nested_key_values(new_conf)

    Enum.reduce(nested_key_values, default_conf, fn {new_key, new_value}, acc ->
      put_in(acc, new_key, new_value)
    end)
  end

  def get_all_nested_key_values(enum, key_values \\ []) do
    nested_key = get_deepest_key_path(enum)
    {nested_value, remaining_enum} = pop_in(enum, nested_key)

    key_values =
      if nested_value == [] or nested_value == %{} do
        key_values
      else
        [{nested_key, nested_value} | key_values]
      end

    Logger.warn("key_values: #{inspect(key_values)}")

    if Enum.empty?(remaining_enum) do
      key_values
    else
      get_all_nested_key_values(remaining_enum, key_values)
    end
  end

  def get_deepest_key_path(enum, path \\ []) do
    first_item = Enum.take(enum, 1)
    Logger.debug("First item: #{inspect(first_item)}")

    {first_key, first_value} =
      if is_enum?(first_item) do
        Enum.unzip(first_item)
      else
        {[], first_item}
      end

    Logger.debug("First value(all): #{inspect(first_value)}")
    first_value = Enum.at(first_value, 0)
    Logger.debug("first key/value: #{inspect(first_key)}/#{inspect(first_value)}")
    path = path ++ first_key
    Logger.debug("path: #{inspect(path)}")

    if is_enum?(first_value) do
      get_deepest_key_path(first_value, path)
    else
      Logger.warn("found path: #{inspect(path)}")
      path
    end
  end

  def is_enum?(value) do
    Keyword.keyword?(value) or is_map(value)
  end
end
