defmodule LiveOdds.CalcOdds do
  def odds(_match_data) do
    <<odd_1, odd_x, odd_2>> = :crypto.rand_bytes(3)

    {odd_1, odd_x, odd_2}
  end
end
