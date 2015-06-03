defmodule AccountTest do
  use ExUnit.Case

  alias LiveOdds.Account

  test "server mantains the balance" do
    Account.start_link(1)

    assert Account.balance(1) == 0
    assert Account.credit(1, 10) == :ok
    assert Account.balance(1) == 10
    assert Account.credit(1, -10) == :error
    assert Account.balance(1) == 10

    assert Account.debit(1, -10) == :error
    assert Account.debit(1, 100) == :error
    assert Account.balance(1) == 10
    assert Account.debit(1, 10) == :ok
    assert Account.balance(1) == 0
  end
end
