defmodule LbSearchex.AreaStatController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    area_stats = PostalService.area_stats(params["country"], params["category"], :by_area)
    json allow_cors(conn), area_stats
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")
end
