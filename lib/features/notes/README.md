# `features/notes/`

Notes & résultats — liste des matières, détail par matière.

## Owner

Dev 4 — branche `feature/notes`.

## Structure

```
notes/
├── domain/
│   └── notes_repository.dart    # contrat + Subject + Grade
├── data/
│   ├── notes_repository_impl.dart   # impl Dio (Sprint 2)
│   └── fake_notes_repository.dart   # données mockées (Sprint 1)
└── presentation/
    ├── notes_screen.dart
    └── subject_detail_screen.dart
```

## Règles

- Démarrer en **Sprint 1 avec `FakeNotesRepository`** — pas de blocage
  backend.
- Toute couleur passe par `ScolarColors`. Pas de hex en dur.
- Une note positive utilise `ScolarColors.success`, négative `ScolarColors.danger`.
