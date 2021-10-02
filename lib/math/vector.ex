defmodule ViaUtils.Math.Vector do
  require Logger
  @enforce_keys [:x, :y, :z]
  defstruct [:x, :y, :z]

  @spec new(number(), number(), number()) :: struct()
  def new(x, y, z \\ 0) do
    %ViaUtils.Math.Vector{
      x: x,
      y: y,
      z: z
    }
  end

  @spec reverse(struct()) :: struct()
  def reverse(vector) do
    %ViaUtils.Math.Vector{
      x: -vector.x,
      y: -vector.y,
      z: -vector.z
    }
  end

  @spec to_string(struct()) :: binary()
  def to_string(vector, num_digits \\ 3) do
    "#{ViaUtils.Format.eftb_map(vector, num_digits)}"
  end
end
