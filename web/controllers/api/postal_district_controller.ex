defmodule LbSearchex.PostalDistrictController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    %{ country: params["country"] |> String.to_atom, category: nil}
    |> Postalex.Service.PostalDistrict.find_by_slug(params["pd_slug"])
    |> postal_district_response(conn)
  end

  def by_key(conn, params) do
    %{ country: params["country"] |> String.to_atom, category: nil}
    |> Postalex.Service.PostalDistrict.find_by_key(params["pd_key"])
    |> postal_district_response(conn)
  end

  def index(conn, params) do
    params["country"]
    |> String.to_atom
    |> Postalex.Service.PostalDistrict.all_with_postal_codes
    |> postal_district_response(conn)
  end

  defp postal_district_response(nil, conn), do: respond_404(conn)
  defp postal_district_response(postal_district, conn) do
    conn |> json(postal_district)
  end

  def respond_404(conn) do
    conn |> put_status(404) |> json %{ error: :not_found }
  end
end
