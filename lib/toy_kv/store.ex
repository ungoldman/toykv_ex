defmodule ToyKV.Store do
  @moduledoc "Pure transactional key value state. No processes."

  alias __MODULE__

  defstruct base: %{}, stack: []

  @type t :: %Store{base: map(), stack: [map()]}

  def new, do: %Store{}

  def set(s, key, value), do: put_current(s, Map.put(current(s), key, value))
  def get(s, key), do: Map.get(current(s), key)
  def delete(s, key), do: put_current(s, Map.delete(current(s), key))
  def count(s, value), do: current(s) |> Map.values() |> Enum.count(&(&1 == value))

  def begin(s), do: %{s | stack: [current(s) | s.stack]}

  def commit(%Store{stack: []}), do: {:error, :no_transaction}
  def commit(%Store{stack: [top | rest]} = s), do: {:ok, put_current(%{s | stack: rest}, top)}

  def rollback(%Store{stack: []}), do: {:error, :no_transaction}
  def rollback(%Store{stack: [_ | rest]} = s), do: {:ok, %{s | stack: rest}}

  defp current(%Store{stack: [top | _]}), do: top
  defp current(%Store{base: base}), do: base

  defp put_current(%Store{stack: [_ | rest]} = s, map), do: %{s | stack: [map | rest]}
  defp put_current(s, map), do: %{s | base: map}
end
