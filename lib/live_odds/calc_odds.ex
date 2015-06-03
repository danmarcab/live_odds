defmodule LiveOdds.CalcOdds do
  def odds(_match_data) do
    <<odd_1>> = :crypto.rand_bytes(1)
    <<odd_x>> = :crypto.rand_bytes(1)
    <<odd_2>> = :crypto.rand_bytes(1)
    {odd_1, odd_x, odd_2}
  end
end
