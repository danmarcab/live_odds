defmodule LiveOdds.Match.Supervisor do

   use Supervisor

   def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
   end

   def start_match(match_id) do
     Supervisor.start_child(__MODULE__, [match_id])
   end

   def stop_match(match_id) do
     Supervisor.terminate_child(__MODULE__, :global.whereis_name(LiveOdds.Match.name(match_id)))
   end

   def init([]) do
     children = [
       worker(LiveOdds.Match, [])
     ]
     supervise(children, strategy: :simple_one_for_one)
   end
end
