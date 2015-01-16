defmodule ServiceHelper do
  def atomize(param) when is_atom(param),   do: param
  def atomize(param) when is_binary(param), do: String.to_atom(param)
end
