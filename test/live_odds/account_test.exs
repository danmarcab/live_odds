defmodule AccountTest do
  use ExUnit.Case

  alias LiveOdds.Account

  test "server mantains the balance" do
    Account.start

    assert Account.balance == 0
    assert Account.credit(10) == :ok
    assert Account.balance == 10
    assert Account.credit(-10) == :error
    assert Account.balance == 10

    assert Account.debit(-10) == :error
    assert Account.debit(100) == :error
    assert Account.balance == 10
    assert Account.debit(10) == :ok
    assert Account.balance == 0
  end
end
