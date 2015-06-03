defmodule SupervisorTest do
  use ExUnit.Case

  alias LiveOdds.Supervisor

  test "server killing child ressurects child " do
     Supervisor.start_link
     pid = Process.whereis(LiveOdds.PubSub)
     pid2 = Process.whereis(LiveOdds.Account.Supervisor)
     Process.exit(pid, 'Pubsub dead')
     Process.exit(pid2, 'Account Bankcrupt')
     :timer.sleep(500)
     assert is_pid(Process.whereis(LiveOdds.PubSub))
     assert is_pid(Process.whereis(LiveOdds.Account.Supervisor))
  end
end
