use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :lb_searchex, LbSearchex.Endpoint,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "7h2sl6VICay1iiZzBr4fB7wNl1yv7eLXMiIlPwr22Z0IeuFrmDUBwL1TIKBfLGms"

config :postalex,
  elastic_server_url: System.get_env("ELASTIC_SERVER_URL"),
  couch_server_url: System.get_env("COUCH_SERVER_URL"),
  couch_user: System.get_env("COUCH_USER"),
  couch_pass: System.get_env("COUCH_PASS")

config :logger,
  level: :info
