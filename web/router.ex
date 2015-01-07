defmodule LbSearchex.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", LbSearchex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/:country/:category", LbSearchex do
    pipe_through :api

    scope "/locations" do
      get "/postal_code", LocationController, :postal_code
      get "/postal_code/neighbours", LocationController, :postal_code_neighbours
    end

    scope "/stats" do
      get "/areas", AreaStatController, :index
      get "/postal_districts", PostalDistrictStatController, :index
      get "/postal_codes", PostalDistrictStatController, :postal_codes
    end

  end
end
