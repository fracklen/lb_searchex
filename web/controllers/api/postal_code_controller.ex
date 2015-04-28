defmodule LbSearchex.PostalCodeController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    requested_postal_code = params["postal_code"]
    atomized_country = params["country"] |> String.to_atom
    postal_code_data = Postalex.Service.PostalCode.fetch_postal_district(%{country: atomized_country, category: nil}, requested_postal_code)
    allowed_cors = allow_cors(conn)
    json(allowed_cors, %{postal_code: postal_code_data[:number], postal_name: postal_code_data[:name]})
  end

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
