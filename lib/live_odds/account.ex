defmodule LiveOdds.Account do

  def start do
    Agent.start(fn() -> %{balance: 0} end, name: :account)
  end

  def balance do
    Agent.get(:account, fn(%{balance: balance}) -> balance end)
  end

  def credit(amount) when is_integer(amount) and amount > 0 do
    Agent.update(:account, fn(%{balance: balance} = state) ->
      %{state| balance: balance + amount}
    end)
  end
  def credit(invalid_amount), do: :error

  def debit(amount) when is_integer(amount) and amount > 0 do
    Agent.get_and_update(:account, &try_debit(&1, amount))
  end
  def debit(invalid_amount), do: :error

  defp try_debit(%{balance: balance} = state, amount) do
    cond do
      balance < amount -> {:error, state}
      true -> {:ok, %{state| balance: balance - amount}}
    end
  end
end
