defmodule LiveOdds.MatchObserver do
  use GenServer

  def start_link do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def matches, do: GenServer.call(__MODULE__, :matches)

  def init([]) do
    Fex.subscribe_matches
    {:ok, []}
  end

  def handle_call(:matches, _from, matches) do
    {:reply, matches, matches}
  end

  def handle_info({:new_match, match_id}, matches) do
    IO.puts "New Match #{match_id}"
    LiveOdds.Match.Supervisor.start_match(match_id)
    {:noreply, [match_id | matches]}
  end

end
