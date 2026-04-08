# CheckBank — Flutter Accessibility Testing Tutorial

**Your eyes lied to you. Your tests are the truth.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## What is this?

CheckBank is a hands-on Flutter accessibility testing tutorial. You start with a polished-looking banking app that passed visual QA — then discover it's broken when tested with assistive technology. Across 11 progressive chapters, you build an automated test suite that catches every accessibility failure, fix the code, and wire it all into a CI pipeline.

The tutorial is delivered through a **browser-based guide** (Docusaurus site) that runs alongside the app. Open the guide in your browser, edit code in your IDE, and see the results instantly on your connected device or simulator. Each chapter follows a **red → green** flow: write a test that fails (red), understand why, fix the code (green). No prior accessibility testing experience is needed — that's what we're here for!

---

## Prerequisites

- [ ] Flutter SDK 3.x+ — [Install Flutter](https://docs.flutter.dev/get-started/install)
- [ ] Node.js 20+ — [nodejs.org](https://nodejs.org) — for the tutorial guide
- [ ] VS Code or Android Studio
- [ ] An iOS device/simulator or Android device/emulator
- [ ] Basic Flutter knowledge (built at least one app)
- [ ] Widget testing basics — if new to Flutter testing, start with [CoreBank Chapter 11](https://corebank-tutorial.dev/chapters/landing)
- [ ] No accessibility testing experience needed!

---

## Quick Start

```bash
git clone git@github.com:team360r/CheckBank.git
cd CheckBank
./setup.sh
```

Then start the tutorial:

```bash
./start.sh
```

This opens the tutorial guide at http://localhost:3000. In another terminal, run the Flutter app on your device/simulator.

Open the project in your IDE:

```bash
code .              # VS Code
# or open the CheckBank/ folder in Android Studio
```

---

## How This Tutorial Works

You work in two windows — the tutorial in your browser, CheckBank in your IDE. Each chapter targets one category of accessibility failure.

| Panel | What's Here |
|-------|-------------|
| **Browser** | Tutorial guide at localhost:3000 — failing tests, explanations, and fix walkthroughs |
| **IDE** | VS Code or Android Studio — where you write tests and fix code |
| **Device** | Your connected device/simulator with hot reload |

### The Red → Green Flow

Every chapter follows the same pattern:
1. **Write a failing test** — the test exposes an accessibility bug
2. **Understand the failure** — learn what the bug means for real users
3. **Fix the code** — make the test pass
4. **Checkpoint** — all tests green, move to the next failure

### Chapter Branches

Every chapter has a matching **git branch** containing the app exactly as it should look after completing that chapter:

| Branch | What it contains |
|--------|-----------------|
| `chapter-0-audit-begins` | Test infrastructure set up, audit checklist identified |
| `chapter-1-labels` | + Semantic label tests and fixes |
| `chapter-2-roles-states` | + Role, state, and custom action tests |
| `chapter-3-contrast` | + WCAG contrast ratio tests and theme fixes |
| `chapter-4-sizing` | + Touch target and text scaling tests |
| `chapter-5-focus` | + Focus traversal and management tests |
| `chapter-6-announcements` | + Live region and announcement tests |
| `chapter-7-integration` | + Integration tests and audit helper |
| `chapter-8-tda` | + Test-driven accessibility (new Quick Pay widget) |
| `chapter-9-linting` | + Custom lint rules for accessibility |
| `chapter-10-ci-pipeline` | + GitHub Actions CI audit pipeline |
| `completed` | The fully tested and fixed app |

**Stuck on a chapter?** Check out the branch to see the solution:

```bash
git checkout chapter-3-contrast
git diff chapter-3-contrast -- test/
git checkout main
```

---

## Chapter Overview

| # | Chapter | Focus | Time |
|---|---------|-------|------|
| 0 | The Audit Begins | All screens — screen reader reveal | ~15 min |
| 1 | Labels Under the Microscope | Login + Dashboard — semantic labels | ~25 min |
| 2 | Roles, States, and Actions | Settings + Transactions — roles, toggles, custom actions | ~30 min |
| 3 | Contrast on Trial | Theme + Settings — WCAG contrast ratios | ~25 min |
| 4 | Touch Targets and Text Scaling | Login + Settings — sizing requirements | ~25 min |
| 5 | Focus Traversal | Login + Transfer — keyboard navigation | ~25 min |
| 6 | Live Regions and Announcements | Login + Notifications — dynamic content | ~30 min |
| 7 | Integration Tests | All screens — cross-screen journeys | ~30 min |
| 8 | Test-Driven Accessibility | New widget — tests before code | ~25 min |
| 9 | Linting and Static Analysis | Config — custom lint rules | ~20 min |
| 10 | The CI Pipeline | GitHub Actions — automated audit | ~25 min |

**Total time:** ~4.5 hours

---

## Project Structure

```
CheckBank/
├── docs-site/                  # Tutorial website (Docusaurus)
│   ├── docs/chapters/          #   11 chapters with stubs
│   ├── src/components/Quiz/    #   Quiz system with progress tracking
│   └── src/theme/              #   Resume banner + visited checkmarks
│
├── lib/                        # CheckBank app (Flutter)
│   ├── screens/                #   Login, Dashboard, Transactions, Transfer, Settings, Notifications
│   ├── widgets/                #   AccountCard, TransactionTile
│   ├── providers/              #   Riverpod state management
│   ├── routing/                #   GoRouter with auth guards
│   ├── data/                   #   Models, mock data (GBP)
│   └── theme/                  #   Material 3 with intentional contrast bugs
│
├── test/                       # Tests (students build these!)
│   └── accessibility/          #   Accessibility test directory
│
├── integration_test/           # Integration tests (Chapter 7)
├── setup.sh                    # Install Flutter + Node deps
└── start.sh                    # Launch tutorial at localhost:3000
```

---

## Tech Stack

**Tutorial site:** Docusaurus 3.9, React 19, TypeScript, Mermaid diagrams

**CheckBank app:** Flutter 3.22+, Riverpod 2.6, GoRouter 14, Drift 2.20, intl

---

## Troubleshooting

**"Tutorial site won't start"**
Check that Node.js 20+ is installed (`node --version`). Then run `cd docs-site && npm install` and try `./start.sh` again.

**"App won't install on my iPhone"**
Run `./setup.sh` again. If you don't have an Apple Developer account, use a simulator instead (`flutter run -d "iPhone 16"`).

**"Hot reload not working"**
Make sure the app is running (`flutter run`) and your device is connected. Save a file to trigger hot reload.

**"Tests are passing when they should fail"**
Make sure you're on the main branch (`git branch`). The chapter branches contain the fixes — main has the bugs.

---

## Contributing & License

This project is licensed under the [MIT License](LICENSE). Contributions are welcome — please open an issue first to discuss any significant changes.

Built with Docusaurus and a deep suspicion of visual QA. Trust your tests, not your eyes.
