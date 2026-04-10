---
name: "Advocatus Diaboli"
description: "Iterative adversariale Review: demontiert Annahmen, sucht Gegenargumente, akkumuliert Erkenntnisse über Sessions hinweg. Trigger: 'advocatus diaboli', 'devil's advocate', 'kritisch durchgehen'."
---

# Advocatus Diaboli — Iterative Adversarial Review

**Gilt für:** Claude Proxmox + Claude Mac  
**Trigger:** "advocatus diaboli" / "devil's advocate" / "kritisch durchgehen"

---

## Zwei Modi

### Modus A: Volle Iteration (Claude Proxmox oder Claude Mac)
- Min. 2, max. 4 Adversarial Review Schleifen
- Erkenntnisse werden nach jeder Session in `living-checklist.md` zurückgeschrieben
- Der Skill wird mit jeder Nutzung besser (Karpathy-Prinzip)
- Kein Kontextfenster-Problem: Zwischenstände explizit dokumentiert

### Modus B: Einzel-Iteration (Cowork)
- Eine Adversarial Review + eine Revision
- Kein Lernmechanismus, kein Filesystem-Zugriff
- Sinnvoll für schnelle Sessions, nicht für komplexe Analysen
- ZIP-Paket: `cowork/advocatus-diaboli.zip`

---

## Ablauf (Modus A)

### Schritt 1 — Analyse entgegennehmen
Bestätige kurz was du als Input erhalten hast. Frage ggf.:
- Gesamte Analyse oder spezifischer Abschnitt?
- Bereits bekannte Schwachstellen?
- Gewünschte Iterations-Tiefe (2–4)?

### Schritt 2 — Living Checklist laden
Lies `living-checklist.md` — das sind die akkumulierten Prüfkriterien aus früheren Sessions. Diese ergänzen die Standard-Checkliste.

### Schritt 3 — Adversarial Review

```
ADVERSARIAL REVIEW — ITERATION [N]

STANDARD-CHECKLISTE:
1. UNGEPRÜFTE ANNAHMEN
   [Zitat + Gegenargument]

2. FEHLENDE GEGENARGUMENTE
   [Was fehlt + warum relevant]

3. BESTÄTIGUNGSFEHLER
   [Narrative wiederholt statt geprüft]

4. BLINDE FLECKEN
   [Was fehlt komplett]

5. OPERATIVE SCHWÄCHE
   [Zu generisch / unrealistisch / risikoignorierend]

SESSION-SPEZIFISCHE KRITERIEN (aus living-checklist.md):
[Einträge aus Living Checklist anwenden]

SCHWÄCHEN GESAMT: [N]
STOP-KRITERIUM ERREICHT: Ja / Nein
```

### Schritt 4 — Diskussion
Welche Schwächen sind berechtigt? Was wird wie tief revidiert?

### Schritt 5 — Revision
Überarbeite die Analyse. Revisionslog anhängen.

### Schritt 6 — Wiederholen bis Stop-Kriterium erfüllt

### Schritt 7 — Living Checklist aktualisieren
Nach Abschluss: Neue Muster und Erkenntnisse in `living-checklist.md` schreiben.  
Format: Was wurde gefunden + in welchem Analysetyp + warum übersehen.

---

## Stop-Kriterium

| Kategorie | Schwellwert |
|-----------|-------------|
| Ungeprüfte Annahmen | ≤ 1 |
| Fehlende Gegenargumente | ≤ 1 |
| Bestätigungsfehler | 0 |
| Blinde Flecken | ≤ 1 |
| Operative Schwäche | ≤ 1 |

**STOP wenn:** Alle unter Schwellwert UND min. 2 Iterationen. Max. 4 Iterationen.

---

## Revisionslog (Pflicht im finalen Output)

```
## Revisionslog

Iteration 1: [N] Schwächen — [Hauptpunkte] → [Änderungen]
Iteration 2: [N] Schwächen — [Hauptpunkte] → [Änderungen] / STOP
Verbleibende Lücken: [ehrlich benennen]
```

---

## Tonalität

- Direkt, keine Weichspüler
- Konkret zitieren
- Schwäche vs. akzeptable Lücke klar trennen
- Unsicherheit explizit benennen
