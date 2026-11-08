defmodule ToyKV.CLITest do
  use ExUnit.Case, async: true
  alias ToyKV.{CLI, Server}

  setup do
    %{kv: start_supervised!(Server)}
  end

  test "commands reach the server", %{kv: kv} do
    assert CLI.eval("SET a 1\n", kv) == :ok
    assert CLI.eval("GET a", kv) == "1"
    assert CLI.eval("COUNT 1", kv) == 1
    assert CLI.eval("DELETE a", kv) == :ok
    assert CLI.eval("GET a", kv) == nil
  end

  test "errors come back as tagged tuples", %{kv: kv} do
    assert CLI.eval("COMMIT", kv) == {:error, :no_transaction}
    assert CLI.eval("NOPE", kv) == {:error, :invalid_command}
    assert CLI.eval("SET a", kv) == {:error, :invalid_command}
  end
end
