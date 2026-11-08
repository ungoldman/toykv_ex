defmodule ToyKV.Server do
  @moduledoc "Holds a ToyKV.Store in a process."
  use GenServer

  alias ToyKV.Store

  # Client API, runs in the caller's process.

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, Keyword.take(opts, [:name]))
  end

  def set(server, key, value), do: GenServer.call(server, {:set, key, value})
  def get(server, key), do: GenServer.call(server, {:get, key})
  def delete(server, key), do: GenServer.call(server, {:delete, key})
  def count(server, value), do: GenServer.call(server, {:count, value})
  def begin(server), do: GenServer.call(server, :begin)
  def commit(server), do: GenServer.call(server, :commit)
  def rollback(server), do: GenServer.call(server, :rollback)

  # Server callbacks, run in the GenServer's own process.

  @impl true
  def init(:ok), do: {:ok, Store.new()}

  @impl true
  def handle_call({:set, key, value}, _from, s), do: {:reply, :ok, Store.set(s, key, value)}
  def handle_call({:get, key}, _from, s), do: {:reply, Store.get(s, key), s}
  def handle_call({:delete, key}, _from, s), do: {:reply, :ok, Store.delete(s, key)}
  def handle_call({:count, value}, _from, s), do: {:reply, Store.count(s, value), s}
  def handle_call(:begin, _from, s), do: {:reply, :ok, Store.begin(s)}
  def handle_call(:commit, _from, s), do: transact(Store.commit(s), s)
  def handle_call(:rollback, _from, s), do: transact(Store.rollback(s), s)

  defp transact({:ok, new}, _old), do: {:reply, :ok, new}
  defp transact({:error, _} = error, old), do: {:reply, error, old}
end
