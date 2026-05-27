# Scolar Mobile

Application mobile Flutter **Scolar** — Android, iOS & Web.
Plateforme scolaire pour les élèves.

## Stack

- **Flutter** (Dart SDK `^3.10.0-290.4.beta`)
- **google_fonts** — DM Serif Display + DM Sans
- **flutter_lints** — analyse statique

## Démarrage rapide

```bash
flutter pub get
flutter run                 # device par défaut
flutter run -d chrome       # web
flutter run -d windows      # desktop
```

## Commandes utiles

| Commande | Action |
|---|---|
| `flutter pub get` | Installer les dépendances |
| `flutter run` | Lancer l'app |
| `flutter analyze` | Lint |
| `dart format .` | Formater le code |
| `flutter test` | Lancer les tests |
| `flutter build apk` | Build Android |
| `flutter build ios` | Build iOS |
| `flutter build web` | Build Web |

## Architecture

Structure **feature-first** — 1 dev = 1 feature = 1 dossier.

```
lib/
├── main.dart              # bootstrap
├── theme/                 # design system (source unique de vérité)
├── core/                  # utils / constantes / API transverses
├── shared/widgets/        # widgets partagés entre features
└── features/
    ├── onboarding/        # → Jerry-M-L
    ├── updates/           # → ArnaudBay
    ├── routing/           # → yadiOs-a-darel
    ├── student/           # → Ashad90
    ├── auth/              # → Demetrius & olyndi
    └── showcase/          # démo vivante du design system
```

## Design system

Tous les tokens (couleurs, typo, espacements, rayons, ombres) sont définis dans `lib/theme/scolar_theme.dart`.
**Aucune valeur en dur** dans le code feature — voir `lib/theme/README.md`.

Polices : **DM Serif Display** (titres) + **DM Sans** (texte courant), chargées via `google_fonts`.

Pour visualiser le design system → lance l'app et ouvre l'écran **Showcase**.

## Pour les devs

Lis **[`ORIENTATION.md`](./ORIENTATION.md)** avant de coder.
Tu y trouveras :
- Le workflow quotidien
- Les règles d'or (design, structure, ton, langue)
- La convention de branches Git (`feature/<ta-feature>`)
- Le suivi de progression sur le GitHub Project
- La checklist pré-PR

## Équipe

| Feature | Responsable |
|---|---|
| #1 Onboarding | Jerry-M-L |
| #2 Automatic Updates | ArnaudBay |
| #4 Routing | yadiOs-a-darel |
| #5 Écrans élève | Ashad90 |
| #6 Registration / Auth | Demetrius-ch & olyndiradjennedora-art |
| Design system | Lead + Design |

## Convention

- UI en **français**, code en **anglais**
- Ton **tutoyé** (« Connecte-toi », pas « Veuillez vous connecter »)
- Imports relatifs à l'intérieur d'une feature, `package:scolar_mobile/...` depuis l'extérieur
