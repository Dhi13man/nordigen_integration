# Contributing to nordigen_integration

Thank you for improving the package. Before changing API behavior, review the
[GoCardless Bank Account Data documentation](https://developer.gocardless.com/bank-account-data/quick-start-guide/).

## Development setup

1. Install a stable [Dart SDK](https://dart.dev/get-dart).
2. Fork and clone the repository.
3. Create a focused branch from the latest `main`.
4. Install dependencies with `dart pub get`.

## Making changes

- Keep public API changes backward-compatible unless the issue explicitly calls
  for a breaking release.
- Add or update deterministic tests for behavioral changes.
- Never put GoCardless credentials, access tokens, account identifiers, or
  customer data in source files, fixtures, logs, commits, or pull requests.
- Use environment variables for opt-in live integration tests. The default test
  suite must remain safe to run without credentials.
- Update `README.md` and `CHANGELOG.md` when users need to know about the change.

Run the same gates as CI before opening a pull request:

```sh
dart format --output=none --set-exit-if-changed .
dart analyze
EXEC_ENV=github_actions dart test
dart pub publish --dry-run
```

On PowerShell, set the test environment with
`$env:EXEC_ENV = 'github_actions'` before running `dart test`.

## Pull requests

Explain why the change is needed, describe any compatibility tradeoffs, and list
the commands used to verify it. Keep unrelated cleanup out of the pull request.
All required checks and review conversations must be complete before merge.

Security vulnerabilities should be reported privately according to
[`SECURITY.md`](SECURITY.md), not through a public issue.
