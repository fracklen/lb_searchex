defmodule LbSearchex.PostalDistrictStatController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    pd_stats = PostalService.area_stats(params["country"], params["category"], :by_district)
    json allow_cors(conn), pd_stats
  end

  def postal_codes(conn, params) do
    json conn, Postalex.Server.postal_codes(params["country"], params["category"])
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")

end
