defmodule LbSearchex.AreaStatController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    json allow_cors(conn), grouped_by_area_sum(params["country"], params["category"])
  end

  defp grouped_by_area_sum(country, category) do
    PostalService.area_sums(country, category)
  end

  defp allow_cors(conn), do: put_resp_header(conn, "Access-Control-Allow-Origin", "*")

end
