defmodule Postalex.Server do
  def locations(ctry_cat, kinds: kinds, postal_districts: postal_districts, sort: sort) do
    {ctry_cat, kinds, postal_districts, sort}
  end
end

defmodule LocaitonServiceTest do
  use ExUnit.Case

  setup do
    ConCache.put(:lb_searchex_cache, :lease_mapping, %{"title" => "title.raw"})
  end

  test "uses raw title" do
    assert LocationService.find("dk", "lease", "office", "1234", "title|asc") ==
      {%{category: :lease, country: :dk}, "office", "1234", [%{"title.raw" => %{"order" => "asc"}}]}
  end
end
