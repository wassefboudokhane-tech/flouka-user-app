# Marketplace Sync — Web → User App

> **Direction of truth: `flouka-web` → `flouka-user-app`.**  
> Web is the design reference. Flutter adapts to match web. Never the reverse.

Dernière mise à jour : 2026-07-30

Repos :
- `flouka-web` (Next.js) → `http://72.60.191.26:3100` — **source of truth**
- `flouka-user-app` (Flutter) — **mirror**

---

## 0. Design tokens (web → mobile)

| Token | Web (`globals.css` / Tailwind) | Flutter |
|-------|-------------------------------|---------|
| Deep / navy | `--flouka-deep` `#35035C` | `AppColor.deepColor` |
| Purple | `--flouka-purple` `#AD46FF` | `AppColor.primaryColor` |
| Lime CTA | `--flouka-lime` `#D7FC70` | `AppColor.limeColor` |
| Red sale | `--flouka-red` `#DF0033` | `AppColor.DealColor` |
| Canvas | `--background` `#F0EEE9` | `AppColor.canvasColor` |
| Border | `#e6ddf2` | `AppColor.borderColor` |
| Typography | Rubik | `google_fonts` + `TextStyleClass` |
| Radius card/btn/pill | 20 / 14 / 100 | `AppRadius` |
| Spacing | web `px-3` / gap-5 | `AppSpacing` (gutter 12, section 20, cardGap 12) |
| Primary CTA | `.fw-btn-primary` | `FloukaPrimaryButton` |
| Search pill | `.fw-searchpill` | `FloukaSearchPill` |

---

## 1. Shared product listing (canonical)

| Role | Web | Flutter |
|------|-----|---------|
| **Card** | `ProductCard.tsx` | `HotDealsHomeContainerWidget` / `FloukaProductCard` |
| **Grid** | `ProductListingGrid.tsx` | `ShopProductsGrid` (uniform 2-col) |
| **Rail** | `ProductRail.tsx` | `MarketplaceProductRail` |

Legacy cards removed: `FilteredProductHomeContainerWidget`, `ProductHomeCardWidget`.

---

## 2. Redesign phases (2026-07-30)

| Phase | Status | Notes |
|-------|--------|-------|
| 0 Design system | Done | Rubik theme, `FloukaPrimaryButton`, `FloukaSearchPill`, `AppRadius` |
| 1 Browse | Done | Home reassurance chips, categories shop-first, nav restyle, uniform grid |
| 2 PDP | Done | Lime ATC, gallery thumbs + pinch zoom, single description, brand vendor ring |
| 3 Cart/Checkout | Done | Canvas, fw-card rows, sticky lime pay CTA |
| 4 Store | Done | Vendor list cards, store details canvas |
| 5 Auth/Account | Done | Login lime CTA, settings deep header + canvas |
| 6 Amazon home | Done | Merch quad cards Mode/Maison, search pill header |
| 7 PDP polish | Done | Chat vendeur, variant pills deep/lime, duplicate buy box fix |
| 8 Amazon browse+ | Done | Under 50 rail, filter sheet, search pill global, related rail unified |

---

## 3. Product detail sections (web order)

1. Gallery + thumbs  
2. Buy box (title, rate, price, COD, attrs, lime ATC)  
3. Reviews + customer images  
4. FBT  
5. Description (single block)  
6. Related rail  

---

## 4. Smoke checklist

### Flutter (post-redesign)
- [x] Home rails + reassurance chips + canvas
- [x] Categories tab search-first + Mode/Maison pills
- [x] Shop grid uniform 2-col ProductCard
- [x] PDP lime ATC, thumbs, no duplicate description
- [x] Cart canvas + lime checkout CTA
- [x] Store/vendor brand cards
- [x] Login lime primary button

### Layout QA (2026-07-30 — phones SE→Pro Max)
- [x] Phase A: `AppSpacing` + clamped `TextStyleClass` + SearchPill unify + 2-col `GridView` + rail height from card estimate + button radii
- [x] Wave 1: bottom nav, home, categories, shop, PDP (SafeArea gutters 12)
- [x] Wave 2: cart (72×72 image), checkout keyboard, stores list/details/products grid
- [x] Wave 3: login/OTP/register keyboard scroll, settings SafeArea header, onboarding tokens
- [x] Wave 4: favorites/recommended grids, orders/notifications/wallet/tickets/reviews/addresses `100.h` shells removed

### Web staging `http://72.60.191.26:3100`
- [ ] Screenshot parity per surface (manual QA)

---

## 5. Workflow

```
1. Change design on flouka-web first
2. Update this doc if tokens/components change
3. Mirror on Flutter (shared card, PDP, auth, colors)
4. Smoke staging web :3100 then Flutter hot-restart
```
