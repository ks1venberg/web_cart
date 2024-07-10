defmodule WebCart do
  use Application

  def start(_type, _args) do
    children = [
      WebCartWeb.Endpoint,
      WebCartWeb.CartServer
    ]

    opts = [strategy: :one_for_one, name: WebCart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    WebCartWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
