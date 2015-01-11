defmodule PostalService do
	alias Postalex.Server
  import ServiceHelper

  def area_stats(country, category, group) do
    ctry_cat = %{ country: atomize(country), category: atomize(category) }
    Postalex.Server.areas(ctry_cat, atomize(group)) |> group_by_area
  end

  defp group_by_area(areas) do
  	{_, groups} = Enum.map_reduce(areas, %{}, fn(area, map)->{0, Map.put(map, area.id, area) } end)
  	groups
  end

end
