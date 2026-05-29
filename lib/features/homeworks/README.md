# `features/homeworks/`

Devoirs à rendre — liste + détail + check.

## Owner

Dev 4 (en complément des notes) ou backlog Sprint 3.

## Structure

```
homeworks/
├── domain/homeworks_repository.dart    # contrat + Homework
├── data/
│   ├── fake_homeworks_repository.dart  # mocks (Sprint 3)
│   └── dio_homeworks_repository.dart   # impl Dio
└── presentation/
    ├── homeworks_providers.dart
    └── homeworks_screen.dart
```

## Règles

- Devoir en retard : `dueDate < today && !isDone` → couleur danger.
- Devoir pour aujourd'hui : couleur primary (même si pas "en retard").
- Tap sur la pastille → toggle `setDone()`, invalide les 2 providers
  (`homeworksProvider` + `pendingHomeworksCountProvider`).
- L'ordre de la liste : pending d'abord (tri par `dueDate`), done à la fin.
