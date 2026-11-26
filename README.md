# Flouka — app année 1 (créateur + acheteur)

Une seule app Flutter, dépôt `flouka-user-app`. Vitrines créateurs et boutiques marques. **Pas de panier Flouka**, **pas d’IAP** : le clic ouvre le site de la marque dans le navigateur.

POS (`flouka-pos`, `flouka-pos-web`) et delivery sont hors année 1.

## Produit

- Accueil, page créateur `/shop/{handle}`, collection, fiche produit, recherche, page marque
- Inscription créateur / marque, onboarding Instagram (démo), ajout d’un produit par URL, sections, stats clics, profil
- Onboarding marque (taux de commission) + tableau de bord marque
- FR + arabe standard, RTL
- Tokens 26 nov. 2026 : `#FFFFFF` `#1F1F1F` `#767676` `#E5E5E5` `#F7F7F7`, Markazi Text / Amiri / DM Sans / IBM Plex Sans Arabic
- Deep links et universal links `https://flouka.app/...` + schéma `flouka://`
- Consentement FR/AR **avant** Clarity / PostHog UE / Firebase+GA4
- Suppression de compte dans l’app (règle Apple)
- Sign in with Apple dès qu’un login social (Google) est proposé

Identifiants :

| | Valeur |
|---|---|
| iOS bundle id | `app.flouka` |
| Android `applicationId` | `app.flouka` |
| Version | `3.0.0+30` |
| `targetSdk` / `compileSdk` | **36** (exigence Play 31 août 2026 pour les nouvelles soumissions) |
| `minSdk` | 24 |

L’ancien id `com.zeroonez.floukastore.user` n’est plus utilisé : listing store neuf.

## Lancer en local

```bash
cp .env.example .env   # laisser les clés vides
flutter pub get
flutter test
flutter run
```

Le catalogue démo (Nour Démo, Maison Démo, photos générées) s’affiche sans API. OTP : n’importe quel code à 6 chiffres. Google / Apple : si le SDK n’est pas configuré, l’app continue en session démo.

## Clés (placeholders seulement)

Voir `.env.example`. Aucune clé réelle n’est dans le dépôt.

| Variable | Rôle |
|---|---|
| `FLOUKA_API_BASE` | API Laravel (`https://api.flouka.app` ou hôte actuel) |
| `POSTHOG_API_KEY` + `POSTHOG_HOST=https://eu.i.posthog.com` | PostHog Cloud UE |
| `CLARITY_PROJECT_ID` | Microsoft Clarity |
| `FIREBASE_*` / `GA4_MEASUREMENT_ID` | Firebase Analytics + GA4 |
| `FLOUKA_CTA_VARIANT=violet` | A/B CTA `#35035C` |

`android/app/google-services.json` et `ios/Runner/GoogleService-Info.plist` sont des **placeholders** (`flouka-placeholder`). Remplacer par les fichiers Firebase du projet `app.flouka` avant une soumission.

Les trackers **ne démarrent pas** tant que l’utilisateur n’a pas accepté l’écran de consentement.

## ATT

Pas d’IDFA, pas de `NSUserTrackingUsageDescription`, `NSPrivacyTracking = false`.  
Si plus tard vous activez un SDK pub / IDFA : ajouter ATT **et** passer `NSPrivacyTracking` à true. Ce n’est pas le cas année 1.

## Liens profonds (étape humaine)

Fichiers d’exemple à servir sur `https://flouka.app` :

- `docs/store/apple-app-site-association` → `https://flouka.app/.well-known/apple-app-site-association` (sans `.json`, `content-type: application/json`)
- `docs/store/assetlinks.json` → `https://flouka.app/.well-known/assetlinks.json`

Remplacer `TEAMID` par l’Apple Team ID et l’empreinte SHA-256 du keystore Play.

## Comptes et signature — étapes humaines (ne pas faire dans l’agent)

**Ne pas** créer de comptes Apple Developer / Google Play payants ici. **Ne pas** soumettre aux stores. **Ne pas** merger sur `main`.

1. Compte Apple Developer (99 USD/an) au nom de Flouka. Activer Sign in with Apple, Associated Domains, et (plus tard) Push si besoin.
2. Compte Google Play Console (25 USD une fois). Créer l’app `app.flouka`.
3. Keystore Android de production (`key.properties` local, jamais git). Le `keys/keystore.jks` historique n’est pas le store année 1.
4. Certificats iOS / profils via Xcode (équipe `DEVELOPMENT_TEAM` à vérifier).
5. Firebase iOS+Android pour le bundle `app.flouka`, coller les vrais plists/json.
6. Hosting AASA + Digital Asset Links (ci-dessus).
7. Politique de confidentialité et CGU **en ligne** (FR/AR) : `https://flouka.app/legal/privacy` — l’app a déjà les textes, le store exige une URL.
8. Captures store : 6,5" iPhone + 5,5" + tablette ; Play : téléphone 16:9. Dossier agent : `media/y1-app/`.
9. Build : `flutter build apk --release` et, sur macOS avec Xcode : `flutter build ipa`.

### iOS SDK manquant sur cette VM

Cette machine est Linux. `flutter build ios` / `ipa` **n’est pas exécutable ici**. Le projet iOS est à jour (`bundle id`, splash, icône F, `PrivacyInfo.xcprivacy`, entitlements). Builder l’IPA sur un Mac.

### Data Safety (Play Console) — à coller

| Donnée | Collectée | Liée à l’identité | Vendue | Usage |
|---|---|---|---|---|
| E-mail / téléphone | Oui, si compte | Oui | Non | Compte |
| Interactions produit (clics boutique / fiche / marque) | Oui, **si consentement** | Non | Non | Analytics |
| Identifiants utilisateur | Oui, si compte | Oui | Non | Compte |

Pas de localisation, pas de contacts, pas de données financières Flouka (le paiement est chez la marque).  
Pas de pub ciblée. Suppression de compte : Réglages → Supprimer mon compte.

### App Store privacy nutrition

- Data used to track you : **Non**
- Data linked to you : e-mail / téléphone / identifiant de compte si inscription
- Data not linked : analytics d’interaction **après consentement**
- Account deletion : fournie in-app

## Tests et build

```bash
flutter test
flutter build apk --debug
# macOS seulement :
flutter build ios --no-codesign
```

Vérifié sur cette VM (Linux, Flutter 3.50, Gradle 9.5 / AGP 9.3.1, `compileSdk`/`targetSdk` 36) : `flutter test` vert, `flutter build apk --debug` → `build/app/outputs/flutter-apk/app-debug.apk`. IPA iOS non constructible ici.

## Hors périmètre

- Panier / checkout / wallet Flouka
- POS, delivery
- impact.com, IAP, Tabby, Moyasar
- Comptes store payants, soumission, force-push, merge `main`
