# toykv_ex

Elixir port of [toykv](https://github.com/ungoldman/toykv), an in-memory transactional key value store with a REPL.

(toy project, for learning [Elixir](https://elixir-lang.org) and [OTP](https://en.wikipedia.org/wiki/Open_Telecom_Platform) basics)

## start

```
mix run -e ToyKV.CLI.main
```

Type `help` for the commands. Ctrl-D exits.

## layout

- `ToyKV.Store` is the state as plain data: a base map plus a stack of transaction snapshots. No processes.
- `ToyKV.Server` is a GenServer holding a `Store`, started under the app's supervisor as `ToyKV.Server`.
- `ToyKV.CLI` reads lines with `IO.gets`, parses them, and calls the server.

## test

```
mix test
```
