defmodule LiveOdds.App do

  use Application

  def start(_type, _args) do
    {:ok, _pid} = LiveOdds.Supervisor.start_link
  end
end
