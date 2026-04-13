---
title: Mojo Skill Creator v1 — Cross-Platform Skill Creation & Upgrade
category: feature
date: 2026-04-13
tags: [skill-creation, cross-platform, token-efficiency, constraints-first]
---

# Mojo Skill Creator v1

## Context

Existing skill creators (Anthropic's skill-creator, superpowers:writing-skills) are Claude Code-specific — tied to init_skill.py, package_skill.py, and plugin directory structure. Four major agent platforms (Claude Code, Codex, Gemini CLI, OpenClaw) now share SKILL.md as a de facto standard, creating an opportunity for a universal skill creator.

## Problem

Need a skill that can:
1. Create new skills targeting any agent platform
2. Diagnose and upgrade existing skills' quality level
3. Keep token footprint minimal through architectural layering
4. Integrate design methodology from ljg-skills and human-workflow research

## What Was Tried

**Approach A (single SKILL.md)**: Rejected — would exceed 3000 words, violating progressive disclosure.
**Approach C (two separate skills)**: Rejected — shared methodology would be duplicated.
**Approach B (router + references)**: Adopted — thin SKILL.md routes to sub-command workflows, shared references serve both paths.

## Solution

4-layer token architecture:
- Layer 0: Metadata (~50-100 tokens, always loaded)
- Layer 1: SKILL.md router (477 words, loaded on trigger)
- Layer 2: Sub-command workflows in references/ (~1200-1300 words each, one loaded per invocation)
- Layer 3: Deep references (~750-960 words each, loaded on-demand)

Two sub-commands:
- `new`: 8-step workflow (understand → red lines → token architecture → resources → create → observability → validate → iterate)
- `boost`: 4-phase workflow (diagnosis → prescription → execution → report)

Six integrated design dimensions: structural foundation, design philosophy, quality leap methodology, cross-platform adaptation, token efficiency, human observability.

## Why It Worked

1. **SKILL.md as its own proof**: 477 words proves a feature-rich skill can be lightweight. Reviewers can verify the architecture by examining the skill itself.
2. **Shared references across sub-commands**: design-philosophy.md and anti-patterns-by-domain.md serve both `new` and `boost`, avoiding duplication.
3. **Red lines as quality floor**: 6 mechanically checkable constraints are more reliable than pages of "best practice" guidance.

## Generalized Pattern

**"Architecture-as-Demonstration" pattern**: When building a tool that teaches a methodology, make the tool itself the primary example of that methodology. The skill's own file structure, token budget, and design decisions serve as living documentation that users can inspect, copy, and adapt. This eliminates the gap between "what the tool says" and "what the tool does."

**"Thin Router + Fat References" pattern**: For skills with multiple workflows or modes, keep the always-loaded SKILL.md as a pure routing layer (≤500 words) that points to sub-command-specific workflow files. Only one workflow loads per invocation, keeping total context under budget.

## Prevention

- When creating multi-mode skills, default to router pattern from the start (don't consolidate into one file then refactor later)
- Always measure actual word counts before declaring token budgets (review caught 35-53% overestimates)
- Every red line gets the "two reviewers" test during review: would independent reviewers agree on pass/fail?
