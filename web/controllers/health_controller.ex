defmodule LbSearchex.HealthController do
  use Phoenix.Controller

  plug :action

  def index(conn, _) do
    response = %{responses: ping_all}
      |> create_response

    conn
      |> put_status(response.status)
      |> json(response)
  end

  defp ping_all do
    Postalex.Server.ping
      |> Enum.map &(to_map(&1))
  end

  defp create_response(%{ responses: responses }) do
    error_code(errors?(responses))
      |> Map.put(:responses, responses)
  end

  defp error_code(true),  do: %{error: "ping errors", status: 500}
  defp error_code(false), do: %{ok:    "all ok"     , status: 200}

  defp errors?(responses), do: Enum.any?(responses, &(error?(&1)))

  defp error?(%{error: _}), do: true
  defp error?(%{ok:    _}), do: false

  defp to_map({:error, msg}), do: %{error: msg}
  defp to_map({:ok,    msg}), do: %{ok:    msg}
end
