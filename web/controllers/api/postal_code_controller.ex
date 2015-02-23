defmodule LbSearchex.PostalCodeController do
  use Phoenix.Controller

  plug :action

  def postal_district(conn, params) do
    %{country: params["country"] |> String.to_atom, category: nil}
    |> Postalex.Service.PostalCode.postal_district_id(params["postal_code"])
    |> pd_response(conn)
  end

  defp pd_response(nil, conn) do
    conn
    |> put_status(404)
    |> allow_cors
    |> json %{error: :not_found}
  end
  defp pd_response(postal_district_id, conn) do
    conn
    |> allow_cors
    |> json %{id: postal_district_id}
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")

end
