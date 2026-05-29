# `features/schedule/`

Emploi du temps — vue semaine, navigation semaine ±1.

## Owner

Dev 5 — branche `feature/schedule`.

## Structure

```
schedule/
├── domain/
│   └── schedule_repository.dart    # contrat + CourseSlot
├── data/
│   ├── schedule_repository_impl.dart    # impl Dio (Sprint 2)
│   └── fake_schedule_repository.dart    # données mockées (Sprint 1)
└── presentation/
    ├── schedule_screen.dart
    └── widgets/
        └── week_navigator.dart
```

## Règles

- Une semaine = `DateTime weekStart` aligné au **lundi 00h00 local**.
- Démarrer en **Sprint 1 avec `FakeScheduleRepository`**.
- Cours en cours = highlight avec `ScolarColors.primary` + badge.
