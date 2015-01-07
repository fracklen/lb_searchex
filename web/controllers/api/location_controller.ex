defmodule LbSearchex.LocationController do
  use Phoenix.Controller

  plug :action

  def postal_code(conn, params) do
    IO.inspect params["postal_codes"]
    json conn, locations_by_postal_codes(params["country"], params["category"], params["postal_codes"])
  end

   def postal_code_neighbours(conn, params) do
    json conn, neighbour_locations_by_postal_codes(params["country"], params["category"], params["postal_codes"])
  end

  defp locations_by_postal_codes(country, category, nil) do
  	nil
  end

  defp locations_by_postal_codes(country, category, postal_codes) do
  	Postalex.Server.locations([country: country, category: category,postal_codes: postal_codes])
  end

  defp neighbour_locations_by_postal_codes(country, category, nil) do
  	nil
  end

  defp neighbour_locations_by_postal_codes(country, category, postal_codes) do
  	Postalex.Server.neighbour_locations([country: country, category: category,postal_codes: postal_codes])
  end

end
