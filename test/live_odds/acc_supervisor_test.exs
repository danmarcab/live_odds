defmodule AccountSupervisorTest do
  use ExUnit.Case

  alias LiveOdds.Account
  alias LiveOdds.Account.Supervisor

  test "start and stop accounts" do
     Supervisor.start_link

     Supervisor.start_account(1)
     assert Account.balance(1) == 0
     Account.credit(1, 100)
     assert Account.balance(1) == 100
     Supervisor.stop_account(1)
     assert {:noproc, _} = catch_exit(Account.balance(1))
  end
end
