defmodule LbSearchex.HealthController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    response = %{ responses: ping_all }
    |> create_response

    conn
    |> put_status(response.status)
    |> json(response)
  end

  defp ping_all do
    Postalex.Server.ping |> Enum.map fn(res)->to_map(res) end
  end

  defp create_response(%{ responses: responses }) do
    error_code(errors?(responses), responses)
    |> Map.put(:responses, responses)
  end

  defp error_code(true, responses), do: %{ error: "ping errors", status: 500 }
  defp error_code(false, responses), do: %{ ok: "all ok", status: 200 }
  defp errors?(responses), do: Enum.any?(responses, fn(x) -> error?(x) end)
  defp error?(%{error: _}), do: true
  defp error?(%{ok: _}), do: false

  defp to_map({:error, msg}), do: %{error: msg}
  defp to_map({:ok, msg}), do: %{ok: msg}
end
