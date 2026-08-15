# home-manager

## Worktrees

Create a new branch and worktree from `main`:

```sh
wt switch --create <branch>
```

Fuzzy-select an existing worktree, local or remote branch, or pull request:

```sh
w
```

Selecting a branch or pull request without a worktree creates one. Type a new
branch name and press `Alt-c` to create it from `main`.

## Worktree status

Reconcile the configured SpecForge and Weft projects and refresh their
worktree status reports:

```sh
wt-status
```

Pass `--verbose` for command-level diagnostics or `--check-config` to validate
the generated project configuration without fetching or changing worktrees.
The command runs only when invoked; it is not scheduled.
