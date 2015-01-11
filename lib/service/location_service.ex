defmodule LocationService do
  alias Postalex.Server
  import ServiceHelper

  def find(country, category, kinds, postal_districts) do
    ctry_cat = %{ country: atomize(country), category: atomize(category) }
    Postalex.Server.locations(ctry_cat, kinds: kinds, postal_districts: postal_districts)
  end

end
