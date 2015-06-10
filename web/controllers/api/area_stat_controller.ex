defmodule LbSearchex.AreaStatController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    conn
    |> allow_cors
    |> json PostalService.area_stats(:by_area, params["country"], params["category"])
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")
end
