defmodule LiveOdds.Account do

  def start_link(account_id) do
    Agent.start_link(fn() -> %{balance: 0} end, name: gname(account_id))
  end

  def stop(account_id) do
    Agent.stop(name(account_id))
  end

  def name(account_id) do
    {__MODULE__, account_id}
  end
  defp gname(account_id) do
    {:global, name(account_id)}
  end

  def balance(account_id) do
    Agent.get(gname(account_id), fn(%{balance: balance}) -> balance end)
  end

  def credit(account_id, amount) when is_integer(amount) and amount > 0 do
    Agent.update(gname(account_id), fn(%{balance: balance} = state) ->
      %{state| balance: balance + amount}
    end)
  end
  def credit(_account_id, _invalid_amount), do: :error

  def debit(account_id, amount) when is_integer(amount) and amount > 0 do
    Agent.get_and_update(gname(account_id), &try_debit(&1, amount))
  end
  def debit(_account_id, _invalid_amount), do: :error

  defp try_debit(%{balance: balance} = state, amount) when balance < amount do
    {:error, state}
  end
  defp try_debit(%{balance: balance} = state, amount) do
    {:ok, %{state| balance: balance - amount}}
  end
end
