defmodule LbSearchex.PostalAreaController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    %{ country: params["country"] |> String.to_atom, category: nil}
    |> Postalex.Service.Area.by_slug(params["area_slug"])
    |> postal_area_response(conn)
  end

  defp postal_area_response(nil, conn), do: respond_404(conn)
  defp postal_area_response(postal_area, conn) do
    postal_area_data = postal_area |> Map.drop([:postal_districts])
    conn |> json(postal_area_data)
  end

  def respond_404(conn) do
    conn |> put_status(404) |> json %{ error: :not_found }
  end
end
