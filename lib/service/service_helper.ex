defmodule ServiceHelper do
  def ctry_cat(country, category), do: %{ country: atomize(country), category: atomize(category) }

  def atomize(param) when is_atom(param),   do: param
  def atomize(param) when is_binary(param), do: String.to_atom(param)
end
