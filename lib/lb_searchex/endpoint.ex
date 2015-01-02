defmodule LbSearchex.Endpoint do
  use Phoenix.Endpoint, otp_app: :lb_searchex

  plug Plug.Static,
    at: "/", from: :lb_searchex

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_lb_searchex_key",
    signing_salt: "tDON3iP9",
    encryption_salt: "ArBTZA5v"

  plug :router, LbSearchex.Router
end
