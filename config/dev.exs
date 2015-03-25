use Mix.Config

config :lb_searchex, LbSearchex.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true

config :postalex,
  elastic_server_url: System.get_env("ELASTIC_SERVER_URL") ||
    "http://localhost:9200",
  couch_server_url: System.get_env("COUCH_SERVER_URL") ||
    "http://127.0.0.1:5984",
  couch_user: System.get_env("COUCH_USER"),
  couch_pass: System.get_env("COUCH_PASS")

# Enables code reloading for development
config :phoenix, :code_reloader, true
