defmodule KindServiceTest do
  use ExUnit.Case

  defmodule PostalServiceStub do
    def area_stats(:by_area, _, _) do
      %{
        "sydsjaelland" => %{
          id: "sydsj",
          name: "Sydsjælland",
          slug: "sydsjaelland",
          sums: %{"office" => 53, "store" => 40, "warehouse" => 36}
        },
        "vestjylland" => %{
          id: "vestjl",
          name: "Vestjylland",
          slug: "vestjylland",
          sums: %{"office" => 65, "store" => 32, "warehouse" => 22}
        }
      }
    end
  end

  test "KindService.kind_stats returns expected map" do
    assert %{"office" => 118, "store" => 72, "warehouse" => 58} ==
      KindService.kind_stats("dk", "lease", PostalServiceStub)
  end
end
