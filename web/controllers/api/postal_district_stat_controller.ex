defmodule LbSearchex.PostalDistrictStatController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    pd_stats = PostalService.area_stats(:by_district, params["country"], params["category"])
    json allow_cors(conn), pd_stats
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")
end
