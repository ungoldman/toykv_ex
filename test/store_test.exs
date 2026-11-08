defmodule ToyKV.StoreTest do
  use ExUnit.Case, async: true
  alias ToyKV.Store

  test "set, get, delete" do
    s = Store.new() |> Store.set("a", "1")
    assert Store.get(s, "a") == "1"
    assert s |> Store.delete("a") |> Store.get("a") == nil
  end

  test "count" do
    s = Store.new() |> Store.set("a", "x") |> Store.set("b", "x") |> Store.set("c", "y")
    assert Store.count(s, "x") == 2
  end

  test "rollback restores the state before begin" do
    s = Store.new() |> Store.set("a", "1") |> Store.begin() |> Store.set("a", "2")
    assert {:ok, s} = Store.rollback(s)
    assert Store.get(s, "a") == "1"
  end

  test "inner commit lands in the outer transaction, not the base" do
    s = Store.new() |> Store.begin() |> Store.begin() |> Store.set("a", "1")
    {:ok, s} = Store.commit(s)
    assert Store.get(s, "a") == "1"
    {:ok, s} = Store.rollback(s)
    assert Store.get(s, "a") == nil
  end

  test "commit and rollback with no open transaction" do
    assert Store.commit(Store.new()) == {:error, :no_transaction}
    assert Store.rollback(Store.new()) == {:error, :no_transaction}
  end
end
