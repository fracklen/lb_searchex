defmodule LbSearchex.LocationController do
  use Phoenix.Controller

  plug :action

  def postal_code(conn, params) do
    request = parse_request(conn.method, fetch_body(conn), params)
    {country, category, postal_districts, kinds} = parse_request(conn.method, fetch_body(conn), params)
    IO.inspect parse_request(conn.method, fetch_body(conn), params)
    locations = LocationService.find(country, category, kinds, postal_districts)
    json allow_cors(conn), locations
  end

  defp parse_request("POST", _body, params), do: query(params)
  defp parse_request("GET","", params), do: query(params)
  defp parse_request("GET", body, params) do
    Map.merge(Poison.decode!(body), params) |> query
  end

  defp query(request) do
    {request["country"], request["category"], request["postal_districts"], kinds(request["kinds"])}
  end

  defp kinds(nil), do: default_kinds
  defp kinds([]), do: default_kinds
  defp kinds(kinds), do: kinds

  defp fetch_body(conn) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    body
  end

  defp default_kinds, do: [:office, :store, :warehouse]

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")

end
