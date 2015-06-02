defmodule LiveOdds.PubSub do
  use GenServer

  def start_link do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def stop, do: GenServer.cast(__MODULE__, :stop)

  def subscribe(topic), do: GenServer.call(__MODULE__, {:subscribe, self, topic})
  def unsubscribe(topic), do: GenServer.call(__MODULE__, {:unsubscribe, self, topic})
  def publish(topic, message), do: GenServer.cast(__MODULE__, {:publish, topic, message})

  def subscribers(topic), do: GenServer.call(__MODULE__, {:subscribers, topic})
  def topics, do: GenServer.call(__MODULE__, :topics)

  def init(_args) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_call({:subscribe, pid, topic}, _from, state) do
    subscribers = suscribers_for(state, topic) |> Set.put(pid)
    Process.link(pid)
    {:reply, :ok, Map.put(state, topic, subscribers)}
  end

  def handle_call({:unsubscribe, pid, topic}, _from, state) do
    subscribers = suscribers_for(state, topic) |> Set.delete(pid)
    Process.unlink(pid)
    {:reply, :ok, Map.put(state, topic, subscribers)}
  end

  def handle_call({:subscribers, topic}, _from, state) do
    {:reply, Set.to_list(suscribers_for(state, topic)), state}
  end

  def handle_call(:topics, _from, state) do
    {:reply, state |> Map.keys, state}
  end

  def handle_call(:topics, _from, state) do
    {:reply, state |> Map.keys, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_cast({:publish, topic, message}, state) do
    for pid <- suscribers_for(state, topic) do
      send(pid, message)
    end
    {:noreply, state}
  end

  def handle_info({:EXIT, pid, reason}, state) do
    state = for {topic, subscribers} <- state do
      new_subscribers = subscribers |> Set.delete(pid)
      {topic, new_subscribers}
    end |> Enum.into %{}

    {:noreply, state}
  end

  defp suscribers_for(state, topic) do
    Map.get(state, topic, HashSet.new)
  end

end
