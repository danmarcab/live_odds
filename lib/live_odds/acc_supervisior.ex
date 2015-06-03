defmodule LiveOdds.Account.Supervisor do

   use Supervisor

   def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
   end

   def start_account(account_id) do
     Supervisor.start_child(__MODULE__, [account_id])
   end

   def stop_account(account_id) do
     Supervisor.terminate_child(__MODULE__, :global.whereis_name(LiveOdds.Account.name(account_id)))
   end

   def init([]) do
     children = [
       worker(LiveOdds.Account, [])
     ]

     supervise(children, strategy: :simple_one_for_one)
   end
end
