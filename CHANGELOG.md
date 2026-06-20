# Changelog

All notable changes to this project will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project does not yet follow Semantic Versioning — entries are dated and
grouped by release.

## [2026-06-20]

### Added
- New behavioral example skill: [`examples/secure-architecture/`](examples/secure-architecture/).
  Seven-layer authorization design checklist: AuthN vs AuthZ separation,
  authorization anchored on stable IDs (not mutable fields), Separation of Duties
  enforced in the data model rather than the UI, protection of authorization
  records themselves, architectural coherence across ADRs, explicit demo facade
  vs. production foundation, and Interface + Adapter isolation for external
  dependencies. Ships with an illustrative `living-checklist.md` covering OTP
  misuse, mutable-field auth anchors, UI-only SoD, and unprotected grant/revoke
  endpoints.
- New behavioral example skill: [`examples/business-analysis/`](examples/business-analysis/).
  Seven-step BABOK/CBAP procedure: Executive Summary & Business Need →
  Stakeholder Analysis → User Personas → Epics and User Stories with binary
  acceptance criteria → Functional and Non-Functional Requirements (with
  measurable criteria, not intent) → Gap Analysis (As-Is → To-Be) → Risk
  Register and Out-of-Scope. Ships with an illustrative `living-checklist.md`
  covering security NFRs at the wrong altitude, empty Out-of-Scope sections,
  non-UI stakeholders mis-templated as portal users, and late glossaries.
- `CHANGELOG.md` (this file).

### Changed
- `README.md`: replaced the "Extensions (Untested)" section with a single
  "Example Skills" reference table. `token-optimization` is now listed as a
  standard example alongside `advocatus-diaboli`, `secure-architecture`,
  `business-analysis`, and `home-assistant`. Production use has validated the
  proactive-activation rule, so the "untested" caveat no longer applies.

### Notes
- All `living-checklist.md` entries in the public examples are **illustrative**:
  plausible patterns shown in the correct format, not entries copied from real
  client or internal work. This is now stated explicitly in the README.
- The framework spec (`framework.md`) is unchanged in this release.
