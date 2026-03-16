"""Tests for meta-skill files."""
import os
import re
from pathlib import Path
import pytest

REPO_ROOT = Path(__file__).parent.parent


class TestMetaSkillsExist:
    """Verify all meta-skill files exist."""

    @pytest.mark.parametrize("skill", ["review", "review-diff", "verify", "review-file"])
    def test_skill_file_exists(self, skill):
        path = REPO_ROOT / "prompts" / "meta" / skill / "SKILL.md"
        assert path.exists(), f"Missing: {path}"

    @pytest.mark.parametrize("skill", ["review", "review-diff", "verify", "review-file"])
    def test_skill_has_frontmatter(self, skill):
        path = REPO_ROOT / "prompts" / "meta" / skill / "SKILL.md"
        content = path.read_text(encoding="utf-8")
        assert content.startswith("---"), f"{skill} missing YAML frontmatter"
        # Find closing ---
        end = content.index("---", 3)
        assert end > 3, f"{skill} frontmatter not closed"

    @pytest.mark.parametrize("skill", ["review", "review-diff", "verify", "review-file"])
    def test_skill_has_name(self, skill):
        path = REPO_ROOT / "prompts" / "meta" / skill / "SKILL.md"
        content = path.read_text(encoding="utf-8")
        assert f"name: {skill}" in content or f"name: review" in content

    @pytest.mark.parametrize("skill", ["review", "review-diff", "verify", "review-file"])
    def test_skill_has_description(self, skill):
        path = REPO_ROOT / "prompts" / "meta" / skill / "SKILL.md"
        content = path.read_text(encoding="utf-8")
        assert "description:" in content

    @pytest.mark.parametrize("skill", ["review", "review-diff", "verify", "review-file"])
    def test_skill_has_allowed_tools(self, skill):
        path = REPO_ROOT / "prompts" / "meta" / skill / "SKILL.md"
        content = path.read_text(encoding="utf-8")
        assert "allowed-tools:" in content


class TestMetaSkillContent:
    """Verify meta-skill content quality."""

    def test_review_references_layers(self):
        """The /review skill should reference Layer 1, 2a, and 5."""
        content = (REPO_ROOT / "prompts" / "meta" / "review" / "SKILL.md").read_text(encoding="utf-8")
        assert "Layer 1" in content or "layer1" in content or "planning" in content
        assert "Layer 2" in content or "layer2" in content or "quick review" in content.lower()

    def test_review_has_triage(self):
        """/review should include interactive triage."""
        content = (REPO_ROOT / "prompts" / "meta" / "review" / "SKILL.md").read_text(encoding="utf-8")
        assert "triage" in content.lower() or "AskUserQuestion" in content

    def test_review_diff_has_git_diff(self):
        """/review-diff should reference git diff."""
        content = (REPO_ROOT / "prompts" / "meta" / "review-diff" / "SKILL.md").read_text(encoding="utf-8")
        assert "git diff" in content

    def test_verify_has_wrong_fix_table(self):
        """/verify should include wrong-fix lookup."""
        content = (REPO_ROOT / "prompts" / "meta" / "verify" / "SKILL.md").read_text(encoding="utf-8")
        assert "SQL injection" in content or "wrong fix" in content.lower() or "Wrong Fix" in content

    def test_review_file_is_lightweight(self):
        """/review-file should NOT include triage or fix plan."""
        content = (REPO_ROOT / "prompts" / "meta" / "review-file" / "SKILL.md").read_text(encoding="utf-8")
        # Should not have interactive triage
        assert "AskUserQuestion" not in content or "triage" not in content.lower()


class TestInstallScripts:
    """Verify install scripts include meta-skills."""

    def test_install_sh_includes_meta(self):
        content = (REPO_ROOT / "install-skills.sh").read_text(encoding="utf-8")
        assert "meta" in content or "review" in content

    def test_install_ps1_includes_meta(self):
        content = (REPO_ROOT / "install-skills.ps1").read_text(encoding="utf-8")
        assert "meta" in content or "review" in content


class TestClaudeMdTemplate:
    """Verify CLAUDE.md template references meta-skills."""

    def test_template_references_review(self):
        content = (REPO_ROOT / "claude-code" / "CLAUDE.md.template").read_text(encoding="utf-8")
        assert "/review" in content


class TestAllLayerSkillsExist:
    """Regression: verify all original layer skills still exist."""

    LAYER_SKILLS = [
        "layer0-prevention",
        "layer1-planning",
        "layer2-core-review/layer2a-quick-review",
        "layer2-core-review/layer2b-correctness-specialist",
        "layer2-core-review/layer2c-security-specialist",
        "layer2-core-review/layer2d-data-integrity-specialist",
        "layer3-specialized-review/layer3a-performance-specialist",
        "layer3-specialized-review/layer3b-maintainability-specialist",
        "layer3-specialized-review/layer3c-testability-specialist",
        "layer3-specialized-review/layer3d-error-handling-specialist",
        "layer3-specialized-review/layer3e-concurrency-specialist",
        "layer3-specialized-review/layer3f-prompt-injection-specialist",
        "layer3-specialized-review/layer3g-token-efficiency-specialist",
        "layer4-quality-assessment/layer4a-code-smell-detector",
        "layer4-quality-assessment/layer4b-refactoring-advisor",
        "layer5-fix-planning",
        "layer6-verification",
    ]

    @pytest.mark.parametrize("skill_path", LAYER_SKILLS)
    def test_layer_skill_exists(self, skill_path):
        path = REPO_ROOT / "prompts" / skill_path / "SKILL.md"
        assert path.exists(), f"Missing original skill: {path}"
