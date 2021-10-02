defmodule ViaUtils.File do
  @moduledoc """
  Documentation for `ViaUtils.File`.
  """

  require Logger

  defmacro default_mount_path, do: "/mnt"

  @spec target?() :: boolean()
  def target?() do
    String.contains?(File.cwd!(), "/srv/erlang")
  end

  @spec mount_usb_drive(binary(), binary()) :: atom()
  def mount_usb_drive(drive_location, mount_path \\ default_mount_path()) do
    drive_location = "/dev/" <> drive_location

    {_resp, error_code} = System.cmd("mount", [drive_location, mount_path])

    if error_code == 0 do
      :ok
    else
      Logger.error("Device at #{drive_location} could not be mounted to #{mount_path}")
    end
  end

  @spec unmount_usb_drive(binary()) :: tuple()
  def unmount_usb_drive(mount_path \\ default_mount_path()) do
    Logger.debug("Unmount USB drive from #{mount_path}")
    System.cmd("umount", [mount_path])
  end

  @spec cycle_mount(binary(), binary()) :: atom()
  def cycle_mount(drive_location, mount_path \\ default_mount_path()) do
    Logger.debug("Cycling usb drive mount")
    unmount_usb_drive(mount_path)
    Process.sleep(500)
    mount_usb_drive(drive_location, mount_path)
    :ok
  end

  @spec get_filenames_with_extension(binary(), binary(), binary()) :: list()
  def get_filenames_with_extension(
        extension,
        subdirectory \\ "",
        mount_path \\ default_mount_path()
      ) do
    path = mount_path <> "/" <> subdirectory
    {:ok, files} = :file.list_dir(path)

    filenames =
      Enum.reduce(files, [], fn file, acc ->
        file = to_string(file)

        if String.contains?(file, extension) do
          [filename] = String.split(file, extension, trim: true)
          acc ++ [filename]
        else
          acc
        end
      end)

    filenames
  end

  @spec read_file(binary, binary, boolean) :: nil | binary
  def read_file(filename, mount_path, trim_trailing_newline) do
    file_contents = ViaUtils.File.read_file(filename, mount_path)

    cond do
      is_nil(file_contents) -> nil
      trim_trailing_newline -> String.trim_trailing(file_contents, "\n")
      true -> file_contents
    end
  end

  @spec read_file(binary, binary) :: nil | binary
  def read_file(filename, mount_path \\ default_mount_path()) do
    case File.read(mount_path <> "/" <> filename) do
      {:ok, result} ->
        result

      other ->
        Logger.error("Read file error: #{inspect(other)}")
        nil
    end
  end

  @spec write_file(binary(), binary(), binary()) :: nil | atom()
  def write_file(filename, mount_path \\ default_mount_path(), binary_to_write) do
    case File.write(mount_path <> "/" <> filename, binary_to_write) do
      :ok ->
        :ok

      other ->
        Logger.error("Write file error: #{inspect(other)}")
        nil
    end
  end

  @spec read_file_target(binary(), binary(), boolean(), boolean()) :: nil | binary()
  def read_file_target(filename, mount_path, write_to_data, trim_trailing_newline) do
    file_contents = read_file_target(filename, mount_path, write_to_data)

    cond do
      is_nil(file_contents) -> nil
      trim_trailing_newline -> String.trim_trailing(file_contents, "\n")
      true -> file_contents
    end
  end

  @spec read_file_target(binary(), binary(), boolean()) :: nil | binary
  def read_file_target(filename, mount_path, write_to_data \\ false) do
    # First check USB drive, as this will override /data folder
    file_contents_binary = ViaUtils.File.read_file(filename, mount_path)

    Logger.debug(
      "read_file_target: contents in #{filename} at #{mount_path}: #{file_contents_binary}"
    )

    file_contents_binary =
      if !is_nil(file_contents_binary) do
        file_contents_binary
      else
        Logger.debug("No #{filename} file found in #{mount_path}. Check /data.")
        file_contents_binary = ViaUtils.File.read_file(filename, "/data")

        Logger.debug(
          "read_file_target: contents in #{filename} at #{mount_path}: #{file_contents_binary}"
        )

        if !is_nil(file_contents_binary) do
          file_contents_binary
        else
          Logger.debug("No #{filename} file found in /data.")
          nil
        end
      end

    if write_to_data and !is_nil(file_contents_binary) do
      :ok = ViaUtils.File.write_file(filename, "/data", file_contents_binary)
    end

    file_contents_binary
  end
end
