defmodule ViaUtils.Constants do
  @moduledoc """
  Documentation for `UtilsConstants`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> UtilsConstants.hello()
      :world

  """
  defmacro gravity, do: 9.80665
  defmacro pi_2, do: 1.5707963
  defmacro pi_4, do: 0.785398
  defmacro two_pi, do: 6.283185
  defmacro rad2deg, do: 57.295779513
  defmacro deg2rad, do: 0.017453293

  defmacro earth_radius_m, do: 6_371_008.8
end
