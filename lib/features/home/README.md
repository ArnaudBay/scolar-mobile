# `features/home/`

Dashboard élève — moyenne générale, cours du jour, devoirs.

## Owner

Dev 3 — Sprint 2 (Dev 1 a posé le squelette en Sprint 0).

## Structure

```
home/
└── presentation/
    └── pages/
        └── student_home_page.dart   # dashboard
```

## Règles

- **Jamais** de hex en dur — passer par `ScolarColors`. Quelques couleurs
  spécifiques au dashboard (navy carte, indigo barre) sont déclarées en
  haut du fichier comme `static const` privées — c'est toléré tant qu'elles
  ne sont pas réutilisées ailleurs.
- Les données viennent de `NotesRepository` + `ScheduleRepository` (mocks
  en Sprint 1, vraie API en Sprint 2).
