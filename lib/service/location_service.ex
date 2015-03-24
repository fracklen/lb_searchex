defmodule LocationService do
  require Logger
  import ServiceHelper

  def find(country, category, kinds, postal_districts, sort) do
    ctry_cat(country, category)
    |> Postalex.Server.locations(kinds: kinds, postal_districts: postal_districts, sort: parse_sort(sort, category))
  end

  def by_bounding_box(country, category, kinds, bounding_box, sort) do
    ctry_cat(country, category)
    |> Postalex.Server.locations(kinds: kinds, bounding_box: bounding_box, sort: parse_sort(sort, category))
  end

  def district_locations_by_postal_code(country, category, kinds, postal_code, sort) do
    ctry_cat(country, category)
    |> Postalex.Server.district_locations(kinds: kinds, postal_code: postal_code, sort: parse_sort(sort, category))
  end

  def find_by_area_slug(country, category, kinds, area_slug, sort) do
    ctry_cat(country, category)
    |> Postalex.Server.locations(kinds: kinds, area_slug: area_slug, sort: parse_sort(sort, category))
  end

  def find_by_postal_district_slug(country, category, kinds, postal_district_slug, sort) do
    ctry_cat(country, category)
    |> Postalex.Server.locations(kinds: kinds, postal_district_slug: postal_district_slug, sort: parse_sort(sort, category))
  end

  # From
  #   title|desc,created_at|asc
  # to
  #   [%{"title" => %{"order" => "desc"}}, %{"created_at" => %{"order" => "asc"}]
  defp parse_sort(nil,         _),               do: []
  defp parse_sort(sort, category),               do: parse_sort([], String.split(sort, ","), category)

  defp parse_sort(acc_list,       [], category), do: acc_list
  defp parse_sort(acc_list, [x | xs], category)  do
    [key, order] = String.split(x, "|")
    key = parse_sort_key(key, category)

    # %{key => order} isn't allowed in Erlang
    [Map.put(%{}, key, %{"order" => order}) | acc_list]
    |> parse_sort(xs, category)
  end

  # Return key, unless mapping contains key => raw_key
  defp parse_sort_key(key, category) do
    case elastic_mapping(category) |> Map.fetch(key) do
      :error         -> key
      {:ok, raw_key} -> raw_key
    end
  end

  defp elastic_mapping(mapping) do
    cache_key = String.to_atom(mapping <> "_mapping")

    ConCache.get_or_store(:lb_searchex_cache, cache_key, fn ->
      Logger.info "Cache for `#{cache_key}` stale. Fetching mapping from ElasticSearch"
      fetch_mapping(mapping)
      |> Map.to_list
      |> parse_mapping
    end)
  end

  defp fetch_mapping(type) do
    # Mappings are nested under the index and then "mappings".
    # Actual fields are then mapped under type and then "properties"
    Elastix.Client.mapping("locations", type)
    |> Map.values
    |> Enum.at(0)
    |> Map.fetch!("mappings")
    |> Map.fetch!(type)
    |> Map.fetch!("properties")
    |> Map.drop(["metadata"])
  end

  defp parse_mapping(raw_list), do: parse_mapping(%{}, raw_list)

  defp parse_mapping(acc_map,       []), do: acc_map
  defp parse_mapping(acc_map, [x | xs])  do
    {key, value} = x

    Map.put(acc_map, key, value |> parse_mapping_value(key))
    |> parse_mapping(xs)
  end

  defp parse_mapping_value(%{"fields" => _}, key), do: key <> ".raw"
  defp parse_mapping_value(%{"type" => _},   key), do: key
end
