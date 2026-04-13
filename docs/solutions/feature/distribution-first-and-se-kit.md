---
title: Distribution-First Principle + Self-Contained SE-Kit Integration
category: feature
date: 2026-04-13
tags: [distribution, self-evolution, se-kit, bundling]
---

# Distribution-First Principle + Self-Contained SE-Kit Integration

## Context

v1 of mojo-skill-creator was designed from the author's perspective. The user pointed out that skills created by this tool are distributed to end users who have no prior setup. This required a fundamental perspective shift.

Separately, skill-se-kit integration was evaluated. Initial proposal was global installation + symlink, which the user correctly rejected — end users don't have skill-se-kit installed.

## Problem

Two issues surfaced:
1. Design decisions assumed the author's environment (global tools, specific paths)
2. Optional enhancements (self-evolution) required external dependencies the end user wouldn't have

## Solution

**Distribution-first as Principle #1**: Every decision evaluated from end user's perspective. Self-contained, zero-config packages.

**Bundled se-kit**: Instead of referencing a global install, copy skill-se-kit protocol files (~48KB) into each skill's `se-kit/` directory. Per-skill data lives in `se-workspace/`. End user receives a complete package.

**Sub-agent isolation**: Self-evolution runs in a dispatched sub-agent, keeping the main skill's context clean. Fallback for platforms without sub-agents: sequential execution with documented token cost impact.

**Upgrade path**: Author uses `boost` to detect outdated `se-kit/` and update it. End user never manages dependencies.

## Why It Worked

The user's challenge ("end users don't have skill-se-kit") exposed a class of assumption: treating the author's environment as the user's environment. Making "distribution-first" an explicit principle prevents this entire class of errors, not just the se-kit case.

## Generalized Pattern

**"Distribution-First" pattern**: When building tools that produce artifacts for others, every design decision must pass the "fresh machine test" — would this work for someone who just downloaded the package onto a clean environment with only the host platform installed?

**"Bundle, Don't Reference" pattern**: For optional dependencies in distributed packages, copy the dependency into the package rather than referencing an external install. Accept the disk cost (~48KB) to eliminate the configuration cost (setup instructions, version mismatches, "it works on my machine").

## Prevention

- Add "fresh machine test" to validation checklists
- When tempted to use a symlink or global path, ask: "Does the end user have this?"
- v1 review missed this because the review personas didn't include a "distribution reviewer" — now the distribution-first principle makes it structural
