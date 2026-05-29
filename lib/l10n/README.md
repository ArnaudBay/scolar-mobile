# `lib/l10n/`

Internationalisation — FR (défaut) + EN (scaffold).

## Fichiers

- `app_fr.arb` — source de référence (template)
- `app_en.arb` — traduction anglaise
- `app_localizations.dart` — généré par `flutter gen-l10n` (ne pas
  éditer à la main, ajouté au .gitignore via le `generate: true` de
  pubspec si désiré)

## Usage

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context).homeGreeting);
```

## Ajouter une chaîne

1. Ajouter la clé dans `app_fr.arb` (camelCase, contextualisé)
2. Ajouter la traduction dans `app_en.arb` (mêmes clés obligatoires)
3. Régénérer : `flutter gen-l10n` (auto-déclenché par `flutter run`)
4. Utiliser dans le code via `AppLocalizations.of(context).maClef`

## Règles

- **Jamais** de chaîne UI hardcodée hors de `lib/l10n/` — toute string
  utilisateur doit passer par AppLocalizations.
- Les clés sont nommées par contexte (`authLoginTitle`, pas `title`).
- Le tutoiement (consigne produit) s'applique uniquement à la version FR.
- L'app par défaut est en FR — EN est un fallback pour les utilisateurs
  anglophones, à valider produit avant prod.

## Migration (en cours)

Les écrans actuels utilisent encore des littéraux FR. La migration vers
`AppLocalizations` se fait progressivement, écran par écran. Priorité :
auth, onboarding, errors → en S4. Le reste suit en S5.
