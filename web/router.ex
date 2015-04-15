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
    pipe_through :browser

    get "/health_check", HealthController, :index
  end

  scope "/api/:country", LbSearchex do
    get "/postal_codes/:postal_code/postal_district", PostalCodeController, :postal_district
    get "/postal_districts/:pd_slug", PostalDistrictController, :show
    get "/postal_districts/by_key/:pd_key", PostalDistrictController, :by_key
    get "/postal_areas/:area_slug", PostalAreaController, :show
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

      get "/area_slug/:area_slug", LocationController, :area_slug
      get "/postal_district_slug/:postal_district_slug", LocationController, :postal_district_slug
    end

    scope "/stats" do
      get "/", StatController, :show
      get "/areas", AreaStatController, :index
      get "/postal_districts", PostalDistrictStatController, :index
      get "/postal_codes", PostalDistrictStatController, :postal_codes
    end

  end
end
