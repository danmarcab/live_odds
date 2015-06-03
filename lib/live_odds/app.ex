defmodule LiveOdds.App do

  use Application

  def start(_type, _args) do
    Fex.set_tick_interval(100)
    {:ok, _pid} = LiveOdds.Supervisor.start_link
  end
end
