defmodule KindService do

  def kind_stats(country, category, service \\ PostalService) do
    service.area_stats(:by_area, country, category)
    |> sums
    |> Enum.reduce(%{}, &(accumulate(&1, &2)))
  end

  defp accumulate(map, current_acc) do
    map |> Enum.reduce(current_acc, &(update_sum(&1, &2)))
  end

  defp update_sum({k, v}, acc) do
    Map.put(acc, k, v + Map.get(acc, k, 0))
  end

  defp sums(map) do
    map |> Enum.map(fn({_, v}) -> v[:sums] end)
  end
end
