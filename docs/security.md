# Security Notes

- Do not place secrets, tokens, API keys, or credentials in this repository.
- Explorers should be read-only.
- Workers may use workspace-write but must stay inside scope.
- Review scripts before running them.
- Install scripts do not modify `config.toml` by default.
- This project does not provide a supply-chain guarantee.
- Enterprise usage should include local review of agent permissions, install paths, and workflow policies.
- Browser automation can expose logged-in sessions; use it only with intentional scope and avoid credential handling.
