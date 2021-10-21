defmodule ViaUtils.Location do
  @moduledoc """
  Documentation for `UtilsLocation`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> UtilsLocation.hello()
      :world

  """
  require Logger
  require ViaUtils.Constants, as: VC
  require ViaUtils.Shared.ValueNames, as: SVN

  defstruct [SVN.latitude_rad(), SVN.longitude_rad(), SVN.altitude_m()]

  @spec new(number(), number(), number()) :: struct()
  def new(lat, lon, alt \\ 0) do
    %ViaUtils.Location{
      SVN.latitude_rad() => lat,
      SVN.longitude_rad() => lon,
      SVN.altitude_m() => alt
    }
  end

  @spec new_degrees(number(), number(), number()) :: struct()
  def new_degrees(lat, lon, alt \\ 0) do
    new(ViaUtils.Math.deg2rad(lat), ViaUtils.Math.deg2rad(lon), alt)
  end

  @spec to_map(struct()) :: map()
  def to_map(location) do
    Map.from_struct(location)
  end

  @spec to_string(map()) :: binary()
  def to_string(
        %{SVN.latitude_rad() => lat, SVN.longitude_rad() => lon, SVN.altitude_m() => alt} =
          _location
      ) do
    lat_str = ViaUtils.Format.eftb(ViaUtils.Math.rad2deg(lat), 5)
    lon_str = ViaUtils.Format.eftb(ViaUtils.Math.rad2deg(lon), 5)
    alt_str = ViaUtils.Format.eftb(alt, 1)
    "lat/lon/alt: #{lat_str}/#{lon_str}/#{alt_str}"
  end

  @spec dx_dy_between_points(struct(), struct()) :: tuple()
  def dx_dy_between_points(
        %{SVN.latitude_rad() => lat1, SVN.longitude_rad() => lon1} = _wp1,
        %{SVN.latitude_rad() => lat2, SVN.longitude_rad() => lon2} = _wp2
      ) do
    dx_dy_between_points(lat1, lon1, lat2, lon2)
  end

  @spec dx_dy_between_points(float(), float(), float(), float()) :: tuple()
  def dx_dy_between_points(latitude1_rad, longitude1_rad, latitude2_rad, longitude2_rad) do
    dpsi =
      :math.log(
        :math.tan(VC.pi_4() + latitude2_rad / 2) / :math.tan(VC.pi_4() + latitude1_rad / 2)
      )

    dlat = latitude2_rad - latitude1_rad
    dlon = longitude2_rad - longitude1_rad

    q =
      if abs(dpsi) > 0.0000001 do
        dlat / dpsi
      else
        :math.cos(latitude1_rad)
      end

    {dlat * VC.earth_radius_m(), q * dlon * VC.earth_radius_m()}
  end

  @spec angle_between_points(struct(), struct()) :: float()
  def angle_between_points(location1, location2) do
    {dx, dy} = dx_dy_between_points(location1, location2)
    ViaUtils.Math.constrain_angle_to_compass(:math.atan2(dy, dx))
  end

  @spec location_from_point_with_dx_dy(struct(), float(), float()) :: struct()
  def location_from_point_with_dx_dy(
        %{SVN.latitude_rad() => lat1, SVN.longitude_rad() => lon1, SVN.altitude_m() => alt1} =
          _starting_point,
        dx,
        dy
      ) do
    dlat = dx / VC.earth_radius_m()
    lat2 = lat1 + dlat
    dpsi = :math.log(:math.tan(VC.pi_4() + lat2 / 2) / :math.tan(VC.pi_4() + lat1 / 2))

    q =
      if abs(dpsi) > 0.0000001 do
        dlat / dpsi
      else
        :math.cos(lat1)
      end

    dlon = dy / VC.earth_radius_m() / q
    lon2 = lon1 + dlon
    # {lat2, lon2}
    new(lat2, lon2, alt1)
  end

  @spec location_from_point_with_distance_bearing(struct(), float(), float()) :: struct()
  def location_from_point_with_distance_bearing(starting_point, distance, bearing) do
    dx = distance * :math.cos(bearing)
    dy = distance * :math.sin(bearing)
    # Logger.debug("dx/dy: #{dx}/#{dy}")
    location_from_point_with_dx_dy(starting_point, dx, dy)
  end
end
