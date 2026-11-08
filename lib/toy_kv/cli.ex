defmodule ToyKV.CLI do
  @moduledoc "Line-based REPL over ToyKV.Server."

  alias ToyKV.Server

  @help """

  Available commands:

  SET <key> <value>   store the value for key
  GET <key>           return the current value for key
  DELETE <key>        remove the entry for key
  COUNT <value>       return the number of keys that have the given value
  BEGIN               start a new transaction
  COMMIT              complete the current transaction
  ROLLBACK            revert to state prior to BEGIN call
  HELP, help, ?       print this help text

  """

  def main do
    case IO.gets("> ") do
      :eof ->
        :ok

      {:error, reason} ->
        IO.puts(:stderr, "Error: #{inspect(reason)}")

      line ->
        line |> eval() |> output()
        main()
    end
  end

  def eval(line, server \\ Server) do
    case String.split(line) do
      ["SET", key, value] -> Server.set(server, key, value)
      ["GET", key] -> Server.get(server, key)
      ["DELETE", key] -> Server.delete(server, key)
      ["COUNT", value] -> Server.count(server, value)
      ["BEGIN"] -> Server.begin(server)
      ["COMMIT"] -> Server.commit(server)
      ["ROLLBACK"] -> Server.rollback(server)
      [cmd] when cmd in ["HELP", "help", "?"] -> {:help, @help}
      [] -> :ok
      _ -> {:error, :invalid_command}
    end
  end

  defp output(:ok), do: :ok
  defp output(nil), do: :ok
  defp output({:help, text}), do: IO.write(text)
  defp output({:error, :no_transaction}), do: IO.puts("Error: No transaction")
  defp output({:error, :invalid_command}), do: IO.puts("Error: Invalid command")
  defp output(value), do: IO.puts(to_string(value))
end
