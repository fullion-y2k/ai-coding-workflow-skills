# AI Coding Workflow Skills

AI コーディングの不要なトークン消費、重複調査、手戻りを減らすための Codex Skill / Custom Agent / ドキュメント一式です。

このリポジトリは「安いモデルを使えば安くなる」という考え方ではありません。mini 系モデルを司令塔にすると、途中脱線、確認不足、原因未特定の実装、手戻りが増えることがあります。ここでは、司令塔と作業員を分け、作業の危険度に応じて Fast Track / Standard / Heavy を切り替えます。

固定の削減率や料金削減は保証しません。料金計算もしません。目的は unnecessary token usage, duplicated investigation, and rework を減らすことです。

## 含まれるもの

- `ai-new-project-delivery`: 新規開発・新機能向け Skill
- `ai-existing-project-change`: 既存修正・不具合修正向け Skill
- OpenAI Codex 向け Custom Agent 例
- インストールスクリプト
- 検証スクリプトと GitHub Actions

## 使い分け

- 新規アプリ、新機能、プロトタイプ: `$ai-new-project-delivery`
- 既存画面の不具合、既存仕様変更、回帰修正: `$ai-existing-project-change`

既存修正では、Fast Track 条件を満たす場合を除き、原因特定前に本実装へ進みません。

長い補足プロンプトを書かなくても動く設計です。例えば次で足ります。

```text
$ai-existing-project-change を使って、仕様書に従って実装して
```

この場合、実際の blocker がない限り、Route Decision、実装、関連チェック、検証、最終報告まで進めます。Route Decision や原因分析だけで止まるのは完了ではありません。

## ルート

| Route | 使う場面 | エージェント | 成果物 | レビュー |
| ----- | -------- | ------------ | ------ | -------- |
| Fast Track | 明確・低リスク・検証容易 | 原則なし、最大1つ | 原則なし | 司令塔が差分と検証を確認 |
| Standard | 通常の複数ステップ作業 | 必要時 explorer、worker 1つ | STATE / WORK-PACKAGE / VERIFICATION | リスクが出たら独立レビュー |
| Heavy | DB/API/auth/security/業務ルール/外部連携など | explorer 最大2つ、worker 1つ | 要件、設計、計画、検証、最終レビュー | critical review と go/no-go |

Standard では、サブエージェントが利用可能で Fast Track と言えるほど小さくない場合、実装 worker を1つ使う前提です。Heavy では、利用可能なら explorer、worker、critical reviewer を使います。使えない場合は、その理由を明記して安全な範囲で単独実行します。

サブエージェントを使いすぎると、逆にトークンが増えます。Fast Track では起動しないこともあります。Heavy では人への確認、原因特定、レビューを省略しません。

## OpenAI Codex profile

許可モデルは `gpt-5.5`、`gpt-5.4`、`gpt-5.4-mini`、利用可能な場合のみ `gpt-5.3-codex` です。reasoning effort はすべて `medium` です。`gpt-5.4-mini` を複数ステップ作業の司令塔にはしません。

## インストール

配布リポジトリ内の Skill は `skills/` にあります。実際のインストール先は `~/.agents/skills/` です。Custom Agent は `agents/openai-codex/` から `~/.codex/agents/` にコピーされます。

```bash
./install.sh
./install.sh --dry-run
./install.sh --with-worker-codex
```

```powershell
.\install.ps1
.\install.ps1 -DryRun
.\install.ps1 -WithWorkerCodex
```

`worker-codex.toml.example` はオプション指定時だけ `worker-codex.toml` としてコピーされます。スクリプトは secret、token、`.env`、`config.toml` を作成・変更しません。

## 使用例

```text
$ai-new-project-delivery 小さな在庫管理Webアプリを作って、テストと検証手順も用意して
$ai-existing-project-change 設定画面の保存失敗を原因特定して修正して
```

## ブラウザ確認

Web アプリでは、利用可能なブラウザツールで確認します。使えない場合は、手動確認手順を書き、browser verification を blocked/manual と明記します。

## 注意

これは厳密なワークフローエンジンではありません。モデル可用性、ブラウザツール、プロジェクト事情によって調整が必要です。重要な変更には人間のレビューを残してください。
