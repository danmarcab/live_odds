defmodule LiveOdds.Match do
  use GenServer

  defstruct [:match_id, :state, :minute, :score, :odds]

  def start_link(match_id) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [match_id], [name: gname(match_id)])
  end

  def name(match_id) do
    {__MODULE__, match_id}
  end
  defp gname(match_id) do
    {:global, name(match_id)}
  end

  def init([match_id]) do
    Fex.subscribe_match(match_id)
    {:ok, %__MODULE__{match_id: match_id}}
  end

  def handle_info({{:fex_match_info, match_id}, match_info}, %__MODULE__{match_id: match_id} = match) do
    IO.puts "Match #{match_id}: #{inspect match_info}"
    match = update_match(match, match_info)
    LiveOdds.PubSub.publish(name(match_id), match.odds)
    {:noreply, match}
  end

  defp update_match(match, {state, minute}) do
    match
    |> Map.put(:state, state)
    |> Map.put(:minute, minute)
    |> Map.put(:odds, LiveOdds.CalcOdds.odds(:match))
  end

  defp update_match(match, {state, minute, score}) do
    update_match(match, {state, minute})
    |> Map.put(:score, score)
  end
end
