defmodule LbSearchex.StatController do
  use Phoenix.Controller

  plug :action

  def show(conn, params) do
    json allow_cors(conn), KindService.kind_stats(params["country"], params["category"])
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")
end
