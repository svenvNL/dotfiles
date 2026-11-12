# Global instructions

## Language

Always talk in ASD-STE100 Simplified Technical English.

## Environment
- Fedora Linux, zsh. Node via Volta, Python via uv (`uv run`, `uv add`; never bare `pip install`).
- Containers: podman or docker. Search with `rg`.
- Work code is hosted on GitLab; use `glab` or the GitLab MCP there, not `gh`. Personal code lives on GitHub.
- Repos are cloned under `~/Developer/<host>/<group>/<repo>`.
- Dotfiles are managed by chezmoi (base + private layers). Edit the chezmoi source, not the target file, then `chezmoi apply`.

## Git
- Conventional Commits: `type(scope): summary` (feat, fix, refactor, docs, test, chore, ci, perf).
- Default branch is `master` on older projects and `main` on newer. Branch before committing if on the default branch.
- Commits are SSH-signed automatically; never pass `--no-gpg-sign` or `--no-verify`.
- Prefer rebasing over merge commits. Never force-push to a shared branch without asking.
- Commit or push only when I ask.

## Working style
- Read existing code and follow its conventions (formatter, linter, test framework) before adding new ones.
- Run the project's own lint, typecheck and test scripts after changes, and report failures verbatim.
- Keep changes scoped to the request; mention unrelated issues instead of fixing them.
- For library APIs, check current docs (context7) rather than relying on memory.
- When a Jira issue key is known, put it in the branch name and MR title.

## Comments
Do not add comments to code by default.

Only add one where a reader who understands the language would still be
surprised — a non-obvious constraint, a workaround for external behaviour, or
a reason a simpler approach does not work.

Never write comments that:

- restate what the code already says
- narrate the change or the session ("added this to fix...", "was previously...")
- label sections of an otherwise readable function

Keep the ones you do write to a line or two, describing the code as it is now.

