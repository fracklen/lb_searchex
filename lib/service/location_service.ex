defmodule LocationService do
  alias Postalex.Server
  import ServiceHelper

  def find(country, category, kinds, postal_districts) do
    ctry_cat = %{ country: atomize(country), category: atomize(category) }
    Postalex.Server.locations(ctry_cat, kinds: kinds, postal_districts: postal_districts)
  end

  def by_bounding_box(country, category, kinds, bounding_box) do
    ctry_cat = %{ country: atomize(country), category: atomize(category) }
    Postalex.Server.locations(ctry_cat, kinds: kinds, bounding_box: bounding_box)
  end

end
