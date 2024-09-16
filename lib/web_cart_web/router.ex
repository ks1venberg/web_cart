defmodule WebCartWeb.Router do
  use WebCartWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WebCartWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebCartWeb do
    pipe_through :browser

    get "/", PageController, :home
    post "/discounts", PageController, :discounts
    post "/add_to_cart", PageController, :add_to_cart
    get "/cart", CartController, :cart
    post "/cart/add", CartController, :add
    post "/cart/drop", CartController, :drop
    post "/cart/remove", CartController, :remove
    post "/cart/empty", CartController, :empty_cart
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:web_cart, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WebCartWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
