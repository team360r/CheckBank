---
sidebar_position: 1
slug: /intro
title: Introduction
description: "Welcome to CheckBank — a test-driven Flutter accessibility tutorial."
---

# Introduction

**CheckBank** is a hands-on Flutter accessibility tutorial for developers who can build apps but haven't focused on making them accessible. You'll start with a banking app that looks fine — but is riddled with accessibility failures only your tests can see.

## What is CheckBank?

CheckBank is a Flutter banking app that appears perfectly functional. The screens render, the buttons respond, the balance updates. But fire up a screen reader, plug in a keyboard, or scale the text to 200%, and the cracks appear everywhere. Your job is to write the tests that expose each failure, then fix the code until every test goes green.

## Who this is for

You're a Flutter developer who can build apps. You know widgets, state management, and navigation. If you've completed CoreBank Chapter 11 (widget testing basics), you're ready. No prior accessibility experience needed — every concept is introduced as you need it.

## The audit metaphor

Imagine you've been hired to audit a banking app for accessibility compliance. The previous developers swore it was accessible — they checked by eye. Your job is to prove them wrong with automated tests, then fix what you find. Every chapter is one section of your audit report.

## How the tutorial works

Every chapter follows a **red-green flow**:

1. **Red** — Write a test that exposes an accessibility bug. Watch it fail.
2. **Green** — Fix the production code until the test passes.
3. **Refactor** — Clean up, extract helpers, and move on.

You'll work in two windows — this tutorial in your browser and the CheckBank app in your IDE.

## Chapter branches

Every chapter has a matching git branch that contains CheckBank exactly as it should look after completing that chapter. The branches build incrementally — `chapter-0-audit-begins` sets up test infrastructure, `chapter-3-contrast` adds colour contrast tests, and so on up to `chapter-10-ci-pipeline` which is the fully audited app.

```bash
# See the finished code for any chapter
git checkout chapter-3-contrast

# Compare your work against the solution
git diff chapter-3-contrast -- lib/ test/

# Go back to where you were
git checkout main
```

:::tip
You don't need to use the branches at all if you're following along — they're a safety net, not a requirement.
:::

## Prerequisites

- Flutter SDK 3.22+ and basic Flutter experience
- Widget testing basics (CoreBank Chapter 11 or equivalent)
- Node.js 20+ (for the tutorial site)
- A device or emulator
- An IDE — VS Code or Android Studio

## Quick Start

```bash
git clone git@github.com:team360r/checkbank.git
cd checkbank
flutter pub get
./start.sh
```

Then head to [Chapter 0: The Audit Begins](/chapters/audit-begins).
