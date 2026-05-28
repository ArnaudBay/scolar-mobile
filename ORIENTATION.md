# Guide d'orientation — Équipe Scolar Mobile

## 1. Le principe central

> **Le `theme/` est la source unique de vérité.** Personne ne décide d'une couleur, d'une taille de texte ou d'un espacement seul. Tout vient de `lib/theme/scolar_theme.dart`.

Si tu as besoin d'un truc qui n'existe pas dans le thème → **tu demandes**, tu ne l'inventes pas dans ton coin.

---

## 2. Workflow quotidien (à suivre dans l'ordre)

### Étape 1 — Avant de coder, tu ouvres le showcase
```bash
flutter run
```
Tu navigues sur l'écran **Showcase** pour voir :
- Les couleurs disponibles
- Les styles de texte
- Les composants déjà existants

→ **Tu ne codes rien tant que tu n'as pas vu ce qui existe déjà.**

### Étape 2 — Tu lis `lib/theme/README.md`
Toutes les règles d'usage des tokens y sont. 5 min de lecture qui t'évitent 2h de retour de PR.

### Étape 3 — Tu codes ton écran dans TA feature
```dart
// ✅ BON
Container(
  padding: EdgeInsets.all(ScolarSpacing.md),
  decoration: BoxDecoration(
    color: ScolarColors.primary,
    borderRadius: ScolarRadius.card,
  ),
  child: Text('Salut', style: ScolarTypography.h2),
)

// ❌ INTERDIT
Container(
  padding: EdgeInsets.all(16),                    // valeur magique
  decoration: BoxDecoration(
    color: Color(0xFF3B82F6),                     // couleur en dur
    borderRadius: BorderRadius.circular(12),      // rayon en dur
  ),
  child: Text('Salut',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // style en dur
  ),
)
```

### Étape 4 — Tu testes sur 3 devices
- Téléphone (iPhone SE / petit Android)
- Téléphone moderne (Pixel / iPhone 14)
- Tablette ou web

→ Si ça casse → tu corriges **avant** de pousser.

### Étape 5 — Tu pousses sur TA branche, tu ouvres une PR vers `develop`
Une PR = **une feature** ou **un écran**. Pas 3 features mélangées.

> ⚠️ **La cible de ta PR est toujours `develop`, jamais `main`.**
> `main` = version stable / production. `develop` = intégration en cours.

---

## 2bis. Git — Branche par feature, PR vers `develop`

**Chacun travaille sur SA branche, jamais directement sur `develop` ni `main`.**

### Les branches du repo
| Branche | Rôle | Qui peut pusher dessus ? |
|---|---|---|
| `main` | Version stable / production | **Personne en direct** — uniquement via merge depuis `develop` (Lead) |
| `develop` | Intégration de toutes les features en cours | **Personne en direct** — uniquement via PR mergée |
| `feature/<nom>` | Ta branche de travail | **Toi seul** |

### Nom de branche = nom de ta feature
| Feature | Branche |
|---|---|
| Onboarding | `feature/onboarding` |
| Automatic Updates | `feature/updates` |
| Routing | `feature/routing` |
| Écrans élève | `feature/student` |
| Registration / Auth | `feature/auth` |

### Commandes de base
```bash
# Créer ta branche depuis develop à jour
git checkout develop
git pull
git checkout -b feature/<ta-feature>

# Travailler, commit régulièrement
git add .
git commit -m "feat(auth): écran login"

# Pousser sur TA branche distante
git push -u origin feature/<ta-feature>
```

### Ouvrir la PR
1. Va sur GitHub → onglet **Pull requests** → **New pull request**
2. **base:** `develop` ← **compare:** `feature/<ta-feature>`
3. Titre clair : `feat(auth): écran login + registration`
4. Description : ce que ça fait + `Closes #X` pour lier l'issue
5. Demande un review au Lead

### Règles
- **1 dev = 1 branche** = ton dossier de feature
- Commits **petits et fréquents** (1 par tâche logique), pas un gros commit à la fin
- Messages clairs : `feat(auth): ...`, `fix(updates): ...`, `style(student): ...`
- **Jamais de PR vers `main`** — toujours vers `develop`
- **Jamais de force push** sur `develop` ni `main`
- Avant d'ouvrir la PR : `git pull origin develop` puis rebase/merge pour éviter les conflits

---

## 2ter. Suivi de progression — GitHub Project

**Tout le monde met à jour son ticket dans le board Project du repo.** C'est le seul moyen pour le Lead et le reste de l'équipe de voir où on en est sans avoir à demander.

### Les colonnes
- **Todo** — pas encore commencé
- **In progress** — tu as créé ta branche et commencé à coder
- **In review** — tu as ouvert une PR, en attente de relecture
- **Done** — PR mergée sur `develop`

### Ce que tu dois faire
1. **Quand tu commences** ta feature → déplace ton issue de **Todo → In progress**
2. **Quand tu ouvres ta PR** → déplace l'issue de **In progress → In review** + lie la PR à l'issue (`Closes #X` dans la description)
3. **Quand la PR est mergée** → l'issue passe en **Done** automatiquement si tu as bien mis `Closes #X`

### Règle d'or
> Si ton ticket n'est pas dans la bonne colonne, **pour le reste de l'équipe, ton travail n'existe pas**.

Mets à jour **au moins une fois par jour** quand tu travailles sur ta feature.

---

## 3. Les règles d'or

### 🎨 Règle Design
| ❌ Jamais | ✅ Toujours |
|---|---|
| `Color(0xFF...)` | `ScolarColors.xxx` |
| `fontSize: 16` | `ScolarTypography.body` |
| `EdgeInsets.all(12)` | `EdgeInsets.all(ScolarSpacing.sm)` |
| `BorderRadius.circular(8)` | `ScolarRadius.button` |
| `GoogleFonts.dmSans(...)` direct | passer par `ScolarTypography` |

### 📁 Règle Structure
- **1 dev = 1 feature** → tu codes dans `lib/features/<ta_feature>/`
- Un widget utilisé dans 2+ features → tu le montes dans `lib/shared/widgets/`
- Une logique partagée (API, utils) → `lib/core/`
- **Tu ne touches JAMAIS** au dossier `lib/theme/` sans validation Lead/Design

### 💬 Règle Ton
Le produit **tutoie** l'utilisateur.
- ✅ "Connecte-toi pour continuer"
- ❌ "Veuillez vous connecter"

### 🌐 Règle Langue
Toute l'UI en **français**. Le code (variables, fonctions) en **anglais**.

---

## 4. "J'ai besoin de…" — Que faire ?

| Situation | Action |
|---|---|
| Une nouvelle couleur | Demande au Lead → on l'ajoute à `ScolarColors` |
| Un nouveau style de texte | Pareil → on l'ajoute à `ScolarTypography` |
| Un composant qui existe peut-être | Vérifie le **Showcase** d'abord |
| Un widget réutilisable | Crée-le dans ta feature, puis monte-le dans `shared/widgets/` si besoin |
| Une route vers un autre écran | Demande à **yadiOs-a-darel** (#4 Routing) |
| Un état utilisateur connecté/déconnecté | Demande à **Demetrius/olyndi** (#6 Auth) |

---

## 5. Avant chaque PR — Checklist

```
[ ] flutter analyze   → 0 erreur, 0 warning
[ ] dart format .     → code formaté
[ ] flutter test      → tous les tests passent
[ ] Je n'ai utilisé AUCUNE couleur/taille en dur
[ ] J'ai testé sur petit ET grand écran
[ ] J'ai mis à jour le Showcase si j'ai ajouté un widget partagé
[ ] Ma PR touche UNE seule feature
```

---

## 6. Qui fait quoi

| Feature | Responsable | Dossier |
|---|---|---|
| Onboarding | Jerry-M-L | `features/onboarding/` |
| Updates auto | ArnaudBay | `features/updates/` |
| Routing | yadiOs-a-darel | `features/routing/` |
| Écrans élève | Ashad90 | `features/student/` |
| Inscription / Auth | Demetrius & olyndi | `features/auth/` |
| Design system | **Lead + Design** | `theme/` + `shared/widgets/` |

---

## 7. Communication

- **Bloqué sur le design** → tag Design dans la PR
- **Bloqué sur l'archi** → tag Lead tech
- **Besoin d'un token (couleur/texte) nouveau** → ouvre une issue avec capture Figma
- **Question rapide** → canal #scolar-mobile

---

## En une phrase

> **Tu codes ta feature dans ton dossier, tu utilises uniquement les tokens du theme, tu testes avant de pousser. Si tu hésites, tu demandes plutôt que d'inventer.**

C'est comme ça qu'on garantit que l'app finie ressemble à ce qui a été designé — et pas à 5 styles différents collés ensemble.
