defmodule PostalService do

	alias Postalex.Server

	def postal_district_stats(country, category) do
    Server.postal_districts(country,category)
  end

  def area_sums(country, category) do
    areas = PostalService.dictricts_by_area(country, category)
    areas
    |> summerize_areas([])
    |> Enum.reduce(%{}, fn(area, areas) -> Map.merge(area, areas) end)
  end

  def dictricts_by_area(country, category) do
  	postal_district_stats(country, category) |> group_by_area(%{}) |> Map.values
	end

  defp group_by_area([], area_grp), do: area_grp
  defp group_by_area([ postal_district | postal_districts ], area_grp) do
    area_grp = add_postal_district(postal_district, postal_district.areas, area_grp)
    group_by_area(postal_districts, area_grp)
  end

  defp add_postal_district(_, [], area_grp), do: area_grp
  defp add_postal_district(postal_district, [ area | areas], area_grp) do
    filters = [:from, :to, :postal_code, :areas,:neighbours, :slug]
    current_grp = Map.get(area_grp, area.key, default_area(area))
    updated_grp = %{ current_grp | postal_codes: [filter_out(postal_district, filters) | current_grp.postal_codes] }
    area_grp = Map.put(area_grp, area.key, updated_grp)
    postal_district |> add_postal_district(areas, area_grp)
  end

  def default_area(area), do: %{ key: area.key, name: area.name, postal_codes: []}

  defp filter_out(pd, []), do: pd
  defp filter_out(pd, [filter | filters]) do
    Map.delete(pd, filter) |> filter_out(filters)
  end

  defp summerize_areas([], summerized_areas), do: summerized_areas
  defp summerize_areas([area | areas], summerized_areas) do
    summerized_area = summerize_area(area.postal_codes, %{})
      |> Map.put(:name, area.name)
    summerized_area = Map.put(%{}, area.key, summerized_area)
    summerize_areas(areas, [ summerized_area | summerized_areas])
  end

  defp summerize_area([], summerized_area), do: summerized_area
  defp summerize_area([postal_district | postal_districts], summerized_area) do
    keys = postal_district.sums |> Map.keys
    summerized_area = summerize(keys, summerized_area, postal_district.sums)
    summerize_area(postal_districts, summerized_area)
  end

  defp summerize([], summerized_area, _), do: summerized_area
  defp summerize([key | keys], summerized_area, postal_district_sums) do
    sum = Map.get(summerized_area, key, 0)
    summerized_area = Map.put(summerized_area, key, sum + Map.get(postal_district_sums, key, 0))
    summerize(keys, summerized_area, postal_district_sums)
  end

end
