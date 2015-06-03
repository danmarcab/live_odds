defmodule SupervisorTest do
  use ExUnit.Case

  alias LiveOdds.Supervisor

  test "server killing child ressurects child " do
     Supervisor.start_link
     pid = Process.whereis(LiveOdds.PubSub)
     pid2 = :global.whereis_name(LiveOdds.Account.name(1))
     Process.exit(pid, 'Pubsub dead')
     Process.exit(pid2, 'Account Bankcrupt')
     :timer.sleep(500)
     assert is_pid(Process.whereis(LiveOdds.PubSub))
     assert :global.whereis_name(LiveOdds.Account.name(1))
  end
end
