defmodule LbSearchex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    LbSearchex.Endpoint.start

    children = []
    opts = [strategy: :one_for_one, name: LbSearchex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LbSearchex.Endpoint.config_change(changed, removed)
    :ok
  end
end
