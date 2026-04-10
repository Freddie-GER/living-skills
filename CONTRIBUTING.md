# Contributing to Living Skills

Living Skills is a framework, not a product. Contributions that make it
more useful in practice are more valuable than contributions that make it
more complete in theory.

---

## What We Welcome

### New Skill Examples

The most valuable contribution is a skill you actually use.

If you have a Living Skill that has grown over real sessions — with a
living-checklist that genuinely reflects what you learned — we want it
in `examples/`. A skill used in production for two months beats a perfectly
structured toy example.

Submit skills for:
- Development workflows (code review, debugging approaches, deployment)
- Infrastructure domains (specific systems, cloud providers, databases)
- Research and analysis methodologies
- Creative or writing workflows

### Implementations in Other Environments

We built this with Claude Code on a two-machine homelab. If you get it
working with Codex, Cursor, a local model, or anything else — document
how you did it in `setup/` and open a PR. Especially interesting: anything
that requires adapting the session rituals for an environment without
native filesystem access.

### Framework Improvements

If you find a case where the framework specification is unclear, contradictory,
or just wrong — open an issue or PR against `framework.md`. The spec should
reflect how the system actually works in practice, not how it was originally
imagined.

### Bug Reports

If something in the framework creates problems in real use, that's a bug.
Open an issue describing what you tried, what you expected, and what happened.

---

## What We Don't Need

- Skill examples that were never used in a real session
- living-checklists that were pre-filled with invented learnings
- Theoretical extensions to the framework without a motivating use case
- Tooling that adds complexity without a clear problem it solves

---

## How to Submit

### For a new skill example

1. Fork the repository
2. Copy `templates/behavioral-skill/` or `templates/domain-skill/` into `examples/<your-skill-name>/`
3. Fill in all three files completely
4. Make sure `living-checklist.md` has real entries from real sessions (dates should be accurate)
5. Open a pull request with a short description: what the skill is for, how long you've used it, what surprised you

### For framework changes

1. Open an issue first — describe the problem you encountered
2. If we agree it's worth fixing, fork and submit a PR against `framework.md`
3. Changes to the spec should be reflected in the templates if applicable

### For setup/environment docs

Just open a PR. New environment documentation is almost always welcome.

---

## Quality Bar

**For skill examples:**
- All three files present and complete
- living-checklist has at least three real entries with accurate dates
- Skill.md has complete frontmatter including `type`
- Session Start and Session End rituals are explicitly described
- If Ralph Loop is used: stop criteria are defined

**For framework changes:**
- Change is motivated by a real use case, not theoretical completeness
- Existing examples still work under the new spec
- The change is described clearly in the PR

---

## A Note on Attribution

Living Skills is a synthesis of ideas from Karpathy's Autoresearch and LLM Wiki
concepts, Anthropic's skill system, and iterative research patterns (Ralph Loop).
We believe in crediting sources clearly. If your contribution builds on other
published work, mention it.

---

## License

By contributing, you agree that your contributions will be licensed under
the same license as this project (MIT).
