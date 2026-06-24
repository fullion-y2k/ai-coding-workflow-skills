#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

try:
    import tomllib
except ModuleNotFoundError:  # pragma: no cover
    print("FAIL: Python 3.11+ is required for tomllib")
    sys.exit(1)


ROOT = Path(__file__).resolve().parent
ALLOWED_MODELS = {"gpt-5.5", "gpt-5.4", "gpt-5.4-mini", "gpt-5.3-codex"}
REQUIRED_SKILLS = {
    "ai-new-project-delivery": [
        "references/artifact-templates.md",
        "references/verification.md",
    ],
    "ai-existing-project-change": [
        "references/artifact-templates.md",
        "references/investigation-and-verification.md",
    ],
}
REQUIRED_AGENT_KEYS = {
    "name",
    "description",
    "model",
    "model_reasoning_effort",
    "sandbox_mode",
    "developer_instructions",
}
FORBIDDEN_MODEL_VALUES = {"5.4mini", "5.4", "5.5", "middle"}


errors: list[str] = []


def require(condition: bool, message: str) -> None:
    if not condition:
        errors.append(message)


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        errors.append(f"{path.relative_to(ROOT)} is not utf-8")
        return ""


def parse_frontmatter(text: str, path: Path) -> dict[str, str]:
    if not text.startswith("---\n"):
        errors.append(f"{path.relative_to(ROOT)} missing YAML frontmatter")
        return {}
    end = text.find("\n---\n", 4)
    if end == -1:
        errors.append(f"{path.relative_to(ROOT)} missing closing YAML frontmatter")
        return {}
    fields: dict[str, str] = {}
    for line in text[4:end].splitlines():
        if not line.strip():
            continue
        if ":" not in line:
            errors.append(f"{path.relative_to(ROOT)} invalid frontmatter line: {line}")
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip()
    return fields


def validate_required_files() -> None:
    for name in ["README.md", "README.ja.md", "LICENSE", "install.sh", "install.ps1"]:
        require((ROOT / name).is_file(), f"{name} exists")
    require((ROOT / ".github/workflows/validate.yml").is_file(), "GitHub workflow exists")


def validate_skills() -> None:
    for skill, references in REQUIRED_SKILLS.items():
        skill_dir = ROOT / "skills" / skill
        require(skill_dir.is_dir(), f"required skill directory exists: {skill}")
        skill_md = skill_dir / "SKILL.md"
        require(skill_md.is_file(), f"{skill}/SKILL.md exists")
        if skill_md.is_file():
            text = read_text(skill_md)
            fields = parse_frontmatter(text, skill_md)
            require(fields.get("name") == skill, f"{skill}/SKILL.md has matching name")
            require(bool(fields.get("description")), f"{skill}/SKILL.md has description")
            require("## Default Completion Contract" in text, f"{skill}/SKILL.md has completion contract")
            require("## Delegated Implementation Contract" in text, f"{skill}/SKILL.md has delegated implementation contract")
            require("## Stop Conditions" in text, f"{skill}/SKILL.md has stop conditions")
            require("## Route Risk Floors" in text, f"{skill}/SKILL.md has route risk floors")
            require("show the current working folder and ask the user to reply OK" in text, f"{skill}/SKILL.md has workspace confirmation gate")
            require("Route Decision is an execution checkpoint" in text, f"{skill}/SKILL.md treats route decision as checkpoint")
            require("Delegate the main implementation to `worker-mini`" in text, f"{skill}/SKILL.md delegates standard implementation to worker-mini")
            require("safer to do directly" in text, f"{skill}/SKILL.md rejects direct-work convenience as no-worker reason")
            require("The Skill itself is the delegation instruction" in text, f"{skill}/SKILL.md treats skill as delegation instruction")
            require("Subagent unavailable:" in text, f"{skill}/SKILL.md requires explicit subagent unavailable marker")
            require("final review incomplete" in text, f"{skill}/SKILL.md requires incomplete review marker when Heavy agents are skipped")
            require("## Delegation Barrier" in text, f"{skill}/SKILL.md has delegation barrier")
            require("usually no more than 3 targeted files or commands" in text, f"{skill}/SKILL.md limits orchestrator pre-delegation context")
            require("Agent plan` must match execution" in text, f"{skill}/SKILL.md requires agent plan to match execution")
            require("Worker owns bounded code edits" in text, f"{skill}/SKILL.md assigns code edits to worker")
            require("initializer data correction" in text, f"{skill}/SKILL.md treats DB initializer correction as Heavy")
            require("## Final Report" in text, f"{skill}/SKILL.md has final report requirements")
        for rel in references:
            require((skill_dir / rel).is_file(), f"{skill}/{rel} exists")


def validate_agents() -> None:
    agent_dir = ROOT / "agents/openai-codex"
    require(agent_dir.is_dir(), "agents/openai-codex exists")
    require(not (agent_dir / "worker-codex.toml").exists(), "worker-codex is only .example")
    for path in sorted(agent_dir.glob("*.toml*")):
        if path.name.endswith(".example"):
            text = read_text(path)
            data = tomllib.loads(text)
        elif path.suffix == ".toml":
            text = read_text(path)
            data = tomllib.loads(text)
        else:
            continue
        missing = REQUIRED_AGENT_KEYS - data.keys()
        require(not missing, f"{path.relative_to(ROOT)} has required keys")
        model = data.get("model")
        require(model in ALLOWED_MODELS, f"{path.relative_to(ROOT)} uses allowed model")
        require(model not in FORBIDDEN_MODEL_VALUES, f"{path.relative_to(ROOT)} avoids forbidden model values")
        require(data.get("model_reasoning_effort") == "medium", f"{path.relative_to(ROOT)} uses medium reasoning")


def validate_language() -> None:
    for path in list((ROOT / "skills").rglob("*.md")) + list((ROOT / "agents").rglob("*.toml*")):
        text = read_text(path).lower()
        require("cost" not in text, f"{path.relative_to(ROOT)} does not mention cost")
        require("credit" not in text, f"{path.relative_to(ROOT)} does not mention credit")
        require("price" not in text, f"{path.relative_to(ROOT)} does not mention price")
    readme = read_text(ROOT / "README.md")
    guaranteed_savings = re.search(r"guarantee[sd]?\s+(?:a\s+)?(?:fixed\s+)?\d+\s*%", readme, re.IGNORECASE)
    require(not guaranteed_savings, "README has no guaranteed percentage savings claim")


def validate_model_mentions() -> None:
    for path in ROOT.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        if path.name == "validate.py":
            continue
        if path.suffix.lower() not in {".md", ".toml", ".example", ".py", ".ps1", ".sh", ".yml", ".yaml"}:
            continue
        text = read_text(path)
        for forbidden in FORBIDDEN_MODEL_VALUES:
            pattern = rf"(?<![A-Za-z0-9.-]){re.escape(forbidden)}(?![A-Za-z0-9.-])"
            require(not re.search(pattern, text), f"{path.relative_to(ROOT)} avoids forbidden model name {forbidden}")
        for model in re.findall(r"gpt-[A-Za-z0-9.-]+", text):
            require(model in ALLOWED_MODELS, f"{path.relative_to(ROOT)} uses allowed model identifier {model}")


def main() -> int:
    validate_required_files()
    validate_skills()
    validate_agents()
    validate_language()
    validate_model_mentions()
    if errors:
        print("FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    print("PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
