defmodule LbSearchex do
  use Application

  @lb_searchex_cache_name :lb_searchex_cache

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    LbSearchex.Endpoint.start

    children = [
      worker(ConCache, [cache_opts, [name: @lb_searchex_cache_name]])
    ]

    opts = [strategy: :one_for_one, name: LbSearchex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LbSearchex.Endpoint.config_change(changed, removed)
    :ok
  end

  defp cache_opts do
    [
      ttl: :timer.hours(1),
      ttl_check: :timer.minutes(5)
    ]
  end
end
