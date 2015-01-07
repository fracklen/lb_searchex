defmodule LbSearchex.PostalDistrictStatController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    pds = PostalService.dictricts_by_area(params["country"], params["category"])
    json allow_cors(conn), pds
  end

  def postal_codes(conn, params) do
    json conn, Postalex.Server.postal_codes(params["country"], params["category"])
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")

end
