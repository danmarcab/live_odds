defmodule LiveOdds.Bettor do
  use GenServer

  def start_link(bettor_id) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, bettor_id, [name: gname(bettor_id)])
  end

  def subscribe(bettor_id, match_id) do
    GenServer.cast(gname(bettor_id), {:subscribe, match_id})
  end

  def name(bettor_id) do
    {__MODULE__, bettor_id}
  end
  defp gname(bettor_id) do
    {:global, name(bettor_id)}
  end

  def init(bettor_id) do
    {:ok, []}
  end

  def handle_cast({:subscribe, match_id}, matches) do
    LiveOdds.PubSub.subscribe(LiveOdds.Match.name(match_id))
    {:noreply, [match_id | matches]}
  end

  def handle_info({match_id, odds}, matches) do
    IO.puts "Match #{match_id}: #{inspect Fex.Match.status(match_id)} odds: #{inspect odds}"
    {:noreply, matches}
  end

end
