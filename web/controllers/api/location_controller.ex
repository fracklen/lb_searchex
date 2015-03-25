defmodule LbSearchex.LocationController do
  use Phoenix.Controller

  plug :action

  def area_slug(conn, params) do
    {country, category, kinds} = parse_request(:default, conn.method, fetch_body(conn), params)
    locations = LocationService.find_by_area_slug(country, category, kinds, params["area_slug"], params["sort"])
    json allow_cors(conn), locations
  end

  def postal_district_slug(conn, params) do
    {country, category, kinds} = parse_request(:default, conn.method, fetch_body(conn), params)
    locations = LocationService.find_by_postal_district_slug(country, category, kinds, params["postal_district_slug"], params["sort"])
    json allow_cors(conn), locations
  end

  def bounding_box(conn, params) do
    {country, category, bounding_box, kinds} = parse_request(:bounding_box, conn.method, fetch_body(conn), params)
    locations = LocationService.by_bounding_box(country, category, kinds, bounding_box, params["sort"])
    json allow_cors(conn), locations
  end

  def postal_district(conn, params) do
    {country, category, postal_districts, kinds} = parse_request(:postal_district, conn.method, fetch_body(conn), params)
    locations = LocationService.find(country, category, kinds, postal_districts, params["sort"])
    json allow_cors(conn), locations
  end

  def district_by_code(conn, params) do
    {country, category, postal_code, kinds} = parse_request(:postal_code, conn.method, fetch_body(conn), params)
    locations = LocationService.district_locations_by_postal_code(country, category, kinds, postal_code, params["sort"])
    json allow_cors(conn), locations
  end

  defp parse_request(req_type, "POST", _,    params), do: query(req_type, params)
  defp parse_request(req_type, "GET",  "",   params), do: query(req_type, params)
  defp parse_request(req_type, "GET",  body, params) do
    request = Map.merge(Poison.decode!(body), params)
    req_type |> query(request)
  end

  defp query(:default, request) do
    category = request["category"]
    kinds = request["kinds"] |> fetch_kinds(category)
    {request["country"], category, kinds}
  end

  defp query(:postal_district, request) do
    category = request["category"]
    kinds = request["kinds"] |> fetch_kinds(category)
    {request["country"], category, request["postal_districts"], kinds}
  end

  defp query(:bounding_box, request) do
    category = request["category"]
    kinds = request["kinds"] |> fetch_kinds(category)
    {request["country"], category, bounding_box(request), kinds}
  end

  defp query(:postal_code, request) do
    category = request["category"]
    kinds = request["kinds"] |> fetch_kinds(category)
    {request["country"], category, request["postal_code"], kinds}
  end

  defp bounding_box(request) do
    [ b_lt_lat, b_lt_lon, t_rt_lat, t_rt_lon ] = request["viewport"] |> String.split(~r{,})
    %{
      bottom_left: %{ lat: b_lt_lat, lon: b_lt_lon },
      top_right: %{  lat: t_rt_lat, lon: t_rt_lon }
    }
  end

  defp fetch_kinds(nil, category),  do: default_kinds(category)
  defp fetch_kinds([], category),   do: default_kinds(category)
  defp fetch_kinds(kinds, _),       do: kinds

  defp fetch_body(conn) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    body
  end

  defp default_kinds("lease"),      do: [:office, :store, :warehouse]
  defp default_kinds("user"),       do: default_kinds("lease")
  defp default_kinds("investment"), do: [:office, :store, :warehouse, :housing]
  defp default_kinds(_),            do: default_kinds("lease")

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")
end
