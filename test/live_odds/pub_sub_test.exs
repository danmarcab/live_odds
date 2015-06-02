defmodule PubSubTest do
  use ExUnit.Case

  alias LiveOdds.PubSub

  test "can subscribe and unsuscribe" do
    PubSub.start_link

    assert PubSub.subscribers("topic") == []
    PubSub.subscribe("topic")
    assert PubSub.subscribers("topic") == [self]
    PubSub.unsubscribe("topic")
    assert PubSub.subscribers("topic") == []

    assert PubSub.topics == ["topic"]
  end

  test "can publish and receives messages" do
    PubSub.start_link

    PubSub.publish("topic", :hello)
    refute_receive :hello

    PubSub.subscribe("topic")
    PubSub.publish("topic", :hello)
    assert_receive :hello
  end

  defmodule Subscriber do
    def init(caller, topics) do
      spawn(fn() -> run(caller, topics) end )
    end

    def run(caller, topics) do
      for topic <- topics, do: PubSub.subscribe(topic)
      receive_message(caller)
    end

    def receive_message(caller) do
      receive do
        message ->
          send(caller, {self, message})
      end
      receive_message(caller)
    end
  end

  test "multiple processes can subscribe to a topic" do
    PubSub.start_link

    pid1 = Subscriber.init(self, ["topic"])
    pid2 = Subscriber.init(self, ["topic"])
    pid3 = Subscriber.init(self, ["topic"])
    :timer.sleep(100)
    PubSub.publish("topic", :hello)

    assert_receive {^pid1, :hello}
    assert_receive {^pid2, :hello}
    assert_receive {^pid3, :hello}
  end

  test "multiple processes can subscribe to multiple topics" do
    PubSub.start_link

    pid1 = Subscriber.init(self, ["topic", "cars"])
    pid2 = Subscriber.init(self, ["cars"])
    pid3 = Subscriber.init(self, ["topic"])
    :timer.sleep(100)
    PubSub.publish("topic", :hello)
    PubSub.publish("cars", :bmw)
    assert_receive {^pid1, :hello}
    assert_receive {^pid1, :bmw}
    assert_receive {^pid2, :bmw}
    assert_receive {^pid3, :hello}
  end
end
