# Scolar — Design System

Système de design officiel de l'application Scolar.

## Utilisation

```dart
import 'package:scolar_mobile/theme/scolar_theme.dart';

MaterialApp(
  theme: ScolarTheme.light,
  home: const HomeScreen(),
);
```

Les polices **DM Serif Display** et **DM Sans** sont fournies via le package
[`google_fonts`](https://pub.dev/packages/google_fonts) — aucun fichier `.ttf`
à embarquer.

## Tokens

### Couleurs — `ScolarColors`

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#0D02FE` | Boutons primaires, accents |
| `primaryDark` | `#0A02CC` | Hover / pressed |
| `secondary` | `#EEF1FF` | Fonds doux |
| `accent` | `#FF6B00` | Mises en valeur, badges |
| `text` | `#0A2540` | Texte principal |
| `muted` | `#6B7B95` | Texte secondaire |
| `white` | `#FFFFFF` | Surfaces |
| `border` | `#E5E9F5` | Séparateurs |
| `background` | `#F7F8FC` | Fond de page neutre |
| `success` | `#10B981` | Validation |
| `danger` | `#EF4444` | Erreur |

### Typographie — `ScolarTypography`

| Token | Police / Taille | Usage |
|---|---|---|
| `display` | DM Serif Display 56 | Splash, hero |
| `h1` | DM Serif Display 36 | Titre d'écran |
| `h2` | DM Serif Display 24 | Titre de section |
| `h3` | DM Serif Display 20 | Sous-titre |
| `numeric` | DM Serif Display 26 | Chiffres en avant |
| `body` | DM Sans 16 | Corps de texte |
| `bodySmall` | DM Sans 14 | Texte secondaire |
| `label` | DM Sans 11 UPPER | Label de champ |
| `button` | DM Sans 15 SemiBold | Texte de bouton |
| `caption` | DM Sans 12 | Méta-info |

### Espacements — `ScolarSpacing`

`xs 4` · `sm 8` · `md 16` · `lg 24` · `xl 32` · `xxl 48` · `xxxl 64`
`screenPadding 24`

### Rayons — `ScolarRadius`

`sm 12` · `md 16` · `lg 20` · `xl 28` · `pill 999`
Versions `BorderRadius` : `all12`, `all16`, `all20`, `all28`, `allPill`.

### Ombres — `ScolarShadows`

`soft` (cartes) · `brand` (CTA bleus) · `elevated` (modales).

## Règles

- **Ne jamais** introduire de nouvelles couleurs sans valider avec Design.
- Utiliser `ScolarColors.X` plutôt que `Color(0xFF…)`.
- Toujours appliquer un rayon de l'échelle `ScolarRadius`.
- Les CTA primaires portent l'ombre `ScolarShadows.brand`.
- Ton produit : **tutoiement**.

Un écran de démonstration vivant existe dans
`lib/features/showcase/showcase_screen.dart`.
