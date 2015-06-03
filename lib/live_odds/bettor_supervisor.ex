defmodule LiveOdds.Bettor.Supervisor do

   use Supervisor

   def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
   end

   def start_bettor(bettor_id) do
     Supervisor.start_child(__MODULE__, [bettor_id])
   end

   def stop_bettor(bettor_id) do
     Supervisor.terminate_child(__MODULE__, :global.whereis_name(LiveOdds.Bettor.name(bettor_id)))
   end

   def init([]) do
     children = [
       worker(LiveOdds.Bettor, [])
     ]
     supervise(children, strategy: :simple_one_for_one)
   end
end
