---
name: gitlab-mr
description: Create or update a GitLab merge request for the current branch using glab. Use when the user asks to open an MR, create a merge request, push for review, or "make a PR" in a repo whose origin is a GitLab host.
---

# GitLab merge request

1. Inspect state: `git status`, `git branch --show-current`, `git remote get-url origin`, and the default branch (`git default-branch`, falling back to `main`).
   - If on the default branch, stop and propose a branch name (`<type>/<JIRA-KEY>-short-slug` when a Jira key is known).
   - If there are uncommitted changes, ask whether to commit them first (Conventional Commits).
2. Review what goes in: `git log --oneline origin/<default>..HEAD` and `git diff --stat origin/<default>...HEAD`.
3. Check for an existing MR: `glab mr list --source-branch "$(git branch --show-current)"`. If one exists, push and report its URL instead of creating a new one.
4. Push with `git push` (upstream is set automatically by `push.autoSetupRemote`).
5. Create: `glab mr create --title "<conventional title>" --description "<body>" --target-branch <default> --remove-source-branch --yes`, adding `--draft` unless the user said it is ready.
   - Description: a short summary, a bullet list of changes, testing done, and a link to the Jira issue if a key is known.
6. Report the MR URL. Do not assign reviewers or merge unless asked.
