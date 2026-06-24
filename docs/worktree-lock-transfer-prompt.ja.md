# Worktree Lock 水平展開プロンプト

以下を対象の Codex Skill / Custom Agent に導入してください。

```text
対象 Skill / Custom Agent に Worktree Lock Protocol を導入してください。

目的:
- subagent / worker / explorer が別 worktree、別 project、別 repo を読んだり編集したりする事故を防ぐ。
- 特に mini / lightweight model が作業場所を推測して移動する挙動を禁止する。
- orchestrator は頭脳として方針・統合・判断を担い、subagent には確認済み worktree 内の限定作業だけを渡す。

Skill 側の必須ルール:
- 実作業・調査・repo search・subagent delegation の前に current working folder / worktree をユーザーに表示し、OK を待つ。
- OK 前に project file を読まない。repo search しない。subagent を起動しない。
- OK 後に Worktree Lock を作る。
- Worktree Lock には以下を含める:
  - Confirmed working folder
  - Expected git top-level
  - Expected branch/worktree name when available
  - Allowed read root
  - Allowed edit root
  - Forbidden sibling worktrees when known
  - Lock verification commands
- Worktree Lock のパスは絶対パスにする。相対パスだけで渡さない。
- Route Decision / Work Package / Handoff Packet / Explorer Ticket / Implementation Handoff / Final Report に Worktree Lock を必ず含める。
- 全 subagent handoff に Worktree Lock を必ず含める。
- subagent には相対パスではなく、Worktree Lock 内の絶対パスを渡す。
- orchestrator と subagent は、検索・読取・編集・テスト・ビルド前に Worktree Lock を照合する。
- confirmed working folder / git top-level / allowed read root / allowed edit root が一致しない場合は作業を止める。
- subagent が `BLOCKER: worktree mismatch` を返した場合、orchestrator は正しい Worktree Lock と handoff を作り直す。
- subagent に推測移動させない。
- repo 名、worktree 名、近いパスから推測して `cd` しない。
- allowed edit root 外を編集しない。
- read-only explorer は `Allowed edit root: none` とする。
- Final Report に `Worktree verified` を含める。

Worktree Lock テンプレート:

Worktree Lock
Confirmed working folder:
Expected git top-level:
Expected branch/worktree name:
Allowed read root:
Allowed edit root:
Forbidden sibling worktrees:
Lock verification commands:
不一致時の停止形式:
BLOCKER: worktree mismatch
Expected:
Actual:
Action needed:

Subagent / Custom Agent 側の必須ルール:
- Worktree Lock が handoff に無い場合は作業しない。
- 読み書き前だけでなく、repo search / file read / test / build の前にも Worktree Lock を照合する。
- current working folder / git top-level / allowed read root / allowed edit root が一致しない場合は `BLOCKER: worktree mismatch` で停止する。
- repo や worktree を推測して cd しない。
- 似た名前の repo / sibling worktree / default cwd を使わない。
- handoff の絶対パスだけを使う。
- allowed read root 外を読まない。
- allowed edit root 外を編集しない。
- read-only agent は編集しない。
- 出力に以下を含める:
  - Worktree Lock used
  - Worktree verified
  - Files read / files changed
  - Blockers

validate script も更新してください:
- Skill 本体に Worktree Lock が含まれること
- Skill 本体に `BLOCKER: worktree mismatch` が含まれること
- Handoff / reference template に Worktree Lock が含まれること
- Agent TOML / Custom Agent instructions に Worktree Lock が含まれること
- Agent TOML / Custom Agent instructions に `BLOCKER: worktree mismatch` が含まれること
- Allowed read root / Allowed edit root / Expected git top-level / Worktree verified が含まれること

install script がある場合:
- Skill を通常の skill install path にコピーする
- Custom Agent を通常の agent install path にコピーする
- 既存ファイルは active discovery path 内に backup として残さず、別 backup directory へ移動する
- dry-run がある場合は Worktree Lock 対応ファイルも対象に含める

注意:
- ユーザーに作業フォルダを確認するだけでは不十分。
- OK 後に作成した Worktree Lock を、orchestrator / subagent / final report まで持ち回ること。
- subagent が間違った場所にいる場合、移動させるのではなく blocker として返させること。
```
