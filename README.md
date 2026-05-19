# conventional-commit-script

[![CI](https://github.com/MasterEvarior/conventional-commit-script/actions/workflows/quality.yaml/badge.svg)](https://github.com/MasterEvarior/conventional-commit-script/actions/workflows/quality.yaml)

An interactive CLI script that guides you through writing
[Conventional Commit](https://www.conventionalcommits.org/) messages.

## Usage

Run directly with Nix (no install required):

```sh
nix run github:MasterEvarior/conventional-commit-script
```

Or enter the dev shell and run the script manually:

```sh
nix develop
python script.py
```

The script will prompt you to select a commit type, scope, whether it is a
breaking change, a short description, and an optional ticket number. It then
offers to run `git commit` for you.

## Git hooks

The repository ships two git hooks under `.githooks/`:

- `commit-msg` — validates that commit messages conform to the Conventional
  Commit format.
- `pre-commit` — runs `nix flake check` before each commit.

When you enter the dev shell (`nix develop`), the hooks are wired up
automatically via `git config core.hooksPath .githooks/`.

## direnv

If you have [direnv](https://direnv.net/) installed, the dev shell is loaded
automatically when you enter the directory:

```sh
direnv allow
```

## Development

Format all files:

```sh
nix fmt
```

Run checks:

```sh
nix flake check
```

## AI Disclaimer

Claude was used to generate the `README.md`.

## License

[MIT](LICENSE)
