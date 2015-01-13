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
    get "/health_check", HealthController, :index
  end

  scope "/api/:country/:category", LbSearchex do
    pipe_through :api

    scope "/locations" do
      get "/postal_district", LocationController, :postal_district
      post "/postal_district", LocationController, :postal_district
      get "/postal_codes/:postal_code/postal_district", LocationController, :district_by_code
      post "/postal_codes/:postal_code/postal_district", LocationController, :district_by_code
      get "/bounding_box", LocationController, :bounding_box
      post "/bounding_box", LocationController, :bounding_box
    end

    scope "/stats" do
      get "/areas", AreaStatController, :index
      get "/postal_districts", PostalDistrictStatController, :index
      get "/postal_codes", PostalDistrictStatController, :postal_codes
    end

  end
end
