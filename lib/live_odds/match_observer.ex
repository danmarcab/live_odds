defmodule LiveOdds.MatchObserver do
  use GenServer

  def start_link do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init([]) do
    Fex.subscribe_matches
    {:ok, :ok}
  end

  def handle_info({:new_match, match_id}, :ok) do
    IO.puts "New Match #{match_id}"
    LiveOdds.Match.Supervisor.start_match(match_id)
    {:noreply, :ok}
  end

end
