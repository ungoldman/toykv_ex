defmodule ToyKV.ServerTest do
  use ExUnit.Case, async: true
  alias ToyKV.Server

  setup do
    %{kv: start_supervised!(Server)}
  end

  test "state persists between calls", %{kv: kv} do
    assert Server.set(kv, "a", "1") == :ok
    assert Server.get(kv, "a") == "1"
    assert Server.count(kv, "1") == 1
  end

  test "transactions", %{kv: kv} do
    :ok = Server.begin(kv)
    :ok = Server.set(kv, "a", "1")
    assert Server.rollback(kv) == :ok
    assert Server.get(kv, "a") == nil
    assert Server.commit(kv) == {:error, :no_transaction}
  end
end
