# Worktree Lock 水平展開プロンプト

以下を他の Codex Skill / Custom Agent に適用してください。

```text
対象 Skill / Agent に Worktree Lock を導入してください。

目的:
- サブエージェントが別 worktree / project / repo を読んだり編集したりする事故を防ぐ。
- 特に軽量 worker が作業場所を推測して移動する挙動を禁止する。

Skill 側の必須ルール:
- 実作業前に current working folder を表示し、ユーザーの OK を待つ。
- OK 後に Worktree Lock を作る。
- Worktree Lock には confirmed working folder, expected git top-level, expected branch/worktree name when available, allowed edit root, forbidden sibling worktrees when known を含める。
- 全 subagent handoff に Worktree Lock を必ず含める。
- subagent には相対パスではなく絶対パスを渡す。
- subagent が Worktree Lock 不一致を返した場合、orchestrator は新しい正しい handoff を作る。subagent に推測移動させない。
- Final Report に Worktree verified を含める。

Custom Agent 側の必須ルール:
- 読み書き前に Worktree Lock を照合する。
- confirmed working folder / git top-level / allowed edit root が一致しない、または Lock がない場合は BLOCKER: worktree mismatch で停止する。
- repo や worktree を推測して cd しない。
- allowed edit root 外を編集しない。
- handoff の絶対パスを使う。

検証:
- validate script が Skill と Agent の両方に Worktree Lock と BLOCKER: worktree mismatch の文言があることを検査する。
```
