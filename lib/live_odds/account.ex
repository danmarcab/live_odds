defmodule LiveOdds.Account do

  def start do
    pid = spawn(__MODULE__, :init, [])
    Process.register(pid, :balance)
    pid
  end

  def balance, do: call(:balance)
  def credit(amount), do: call({:credit, amount})
  def debit(amount), do: call({:debit, amount})


  def init do
    initialize_state
    |> loop
  end

  defp call(message) do
    send(:balance, {:request, self, message})
    receive do
      {:reply, reply} -> reply
    end
  end

  defp reply(pid, message) do
    send(pid, {:reply, message})
  end

  defp loop(%{balance: balance} = state) do
    receive do
      {:request, from, :balance} ->
        reply(from, balance)
        loop(state)
      {:request, from, {:debit, amount}} when amount > 0 and balance >= amount ->
        reply(from, :ok)
        loop(%{state| balance: balance - amount})
      {:request, from, {:credit, amount}} when amount > 0 ->
        reply(from, :ok)
        loop(%{state| balance: balance + amount})
      {:request, from, _} ->
        reply(from, :error)
        loop(state)
      :stop -> terminate(state)
    end

  end

  defp initialize_state do
    %{balance: 0}
  end

  defp terminate(_state) do
    :ok
  end

end
