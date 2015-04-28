defmodule LbSearchex.PostalCodeController do
  use Phoenix.Controller

  plug :action

  def postal_district(conn, params) do
    %{country: params["country"] |> String.to_atom, category: nil}
    |> Postalex.Service.PostalCode.fetch_postal_district(params["postal_code"])
    |> pd_response(conn)
  end

  defp pd_response(%{postal_district_id: id, number: number, name: name}, conn) do
    conn
    |> allow_cors
    |> json %{id: id, postal_code: number, name: name}
  end
  defp pd_response(_, conn) do
    conn
    |> put_status(404)
    |> allow_cors
    |> json %{error: :not_found}
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")

end
