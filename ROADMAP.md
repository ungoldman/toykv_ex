# ROADMAP

- [x] basic repl interface
- [x] evaluator function to parse commands
- [x] SET <key> <value> // store the value for key
- [x] GET <key> // return the current value for key
- [x] DELETE <key> // remove the entry for key
- [x] COUNT <value> // return the number of keys that have the given value
- [x] BEGIN // start a new transaction
- [x] COMMIT // complete the current transaction
- [x] ROLLBACK // revert to state prior to BEGIN call
- [x] prevent COMMIT or ROLLBACK when transactions present
- [x] HELP

## future thoughts

- reimplement db/command relationship as operations applied to db state for easier transaction/rollback pattern
- implement proper atomic transaction flow so a transaction that doesn't apply cleanly gets rejected
- expose commands as programmatic API (require/import)
- add unit tests for exported commands
- accept text file as input
- output dump of db state as text file
- save to disk
