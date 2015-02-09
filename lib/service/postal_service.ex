defmodule PostalService do
  import ServiceHelper

  def area_stats(group, country, category) do
    ctry_cat(country, category)
      |> Postalex.Server.areas(atomize(group))
      |> group_by_area
  end

  defp group_by_area(areas) do
    {_, groups} = Enum.map_reduce(areas, %{}, fn(area, map)->{ 0, Map.put(map, area.slug, area) } end)
    groups
  end

end
