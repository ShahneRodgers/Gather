defmodule Gather.Regions do
  def regions() do
    [:Auckland, :Masterton, :Tauranga, :Dannevirke, :Napier, :Te_Kuiti, :Dargaville,
   :New_Plymouth, :Thames, :Gisbourne, :Paihia, :Tokoroa, :Hamilton, :Palmerston_North,
   :Wellington, :Hastings, :Paraparaumu, :Whakatane, :Kaitaia, :Rotorua, :Whanganui,
   :Kerikeri, :Taumarunui, :Whangarei, :Levin, :Taupo, :Whitianga, :Alexandra,
   :Milford_Sound, :Ashburton, :Motueka, :Blenheim, :Mount_Cook, :Christchurch, :Nelson,
   :Dunedin, :Oamaru, :Gore, :Queenstown, :Greymouth, :Reefton, :Hokitika, :Timaru,
   :Invercargill, :Wanaka, :Kaikoura, :Westport]
  end

  def validate_region(:region, region) do
    if Enum.any? regions(), fn r -> Atom.to_string(r) == region end do
      []
    else
      [region: "must be a valid region or nil"]
    end
  end
end
