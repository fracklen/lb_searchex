defmodule LocationService do
  alias Postalex.Server
  import ServiceHelper

  def find(country, category, kinds, postal_districts) do
    ctry_cat(country, category)
      |> Postalex.Server.locations(kinds: kinds, postal_districts: postal_districts)
  end

  def by_bounding_box(country, category, kinds, bounding_box) do
    ctry_cat(country, category)
      |> Postalex.Server.locations(kinds: kinds, bounding_box: bounding_box)
  end

  def district_locations_by_postal_code(country, category, kinds, postal_code) do
    ctry_cat(country, category)
      |> Postalex.Server.district_locations(kinds: kinds, postal_code: postal_code)
  end

  def find_by_area_slug(country, category, kinds, area_slug) do
    ctry_cat(country, category)
      |> Postalex.Server.locations(kinds: kinds, area_slug: area_slug)
  end

  def find_by_postal_district_slug(country, category, kinds, postal_district_slug) do
    ctry_cat(country, category)
      |> Postalex.Server.locations(kinds: kinds, postal_district_slug: postal_district_slug)
  end

end
