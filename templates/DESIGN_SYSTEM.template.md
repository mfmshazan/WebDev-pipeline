# Design System — <PROJECT NAME>

> Written by `wd-ui-designer` from `docs/design/UX.md` + `docs/research/ui-references.md`.
> Original system — references inspire principles only, never copied palettes/brands.
> Everything here must be buildable with Tailwind + TypeScript components.

## Design Principles
- <3–5 guiding principles for this product, e.g. "clarity over density">

## Design Tokens

### Color
| Token | Role | Light | Dark | Notes |
|-------|------|-------|------|-------|
| `--color-bg` | Page background | `#FFFFFF` | `#0B0B0C` | |
| `--color-surface` | Cards/panels | `#F7F7F8` | `#161618` | |
| `--color-text` | Primary text | `#111113` | `#F5F5F6` | |
| `--color-text-muted` | Secondary text | `#5A5A5E` | `#A0A0A6` | |
| `--color-primary` | Primary action | `#<hex>` | `#<hex>` | |
| `--color-primary-fg` | Text on primary | `#FFFFFF` | `#FFFFFF` | |
| `--color-border` | Borders/dividers | `#E4E4E7` | `#2A2A2E` | |
| `--color-success` / `--color-warning` / `--color-danger` | Status | | | |

### Typography
| Token | Font | Size / Line | Weight | Use |
|-------|------|-------------|--------|-----|
| `display` | <font> | 48 / 56 | 700 | Hero |
| `h1` | <font> | 32 / 40 | 700 | Page title |
| `h2` | <font> | 24 / 32 | 600 | Section |
| `body` | <font> | 16 / 24 | 400 | Default |
| `small` | <font> | 14 / 20 | 400 | Captions |
- **Font families:** Heading `<font>`, Body `<font>`, Mono `<font>`.

### Spacing scale (4px base)
`0, 1=4, 2=8, 3=12, 4=16, 6=24, 8=32, 12=48, 16=64` → map to Tailwind spacing.

### Radius / Shadow / Z-index
- **Radius:** `sm 6px · md 10px · lg 16px · full 9999px`
- **Shadow:** `sm`, `md`, `lg` (define blur/spread/color)
- **Z-index:** `base 0 · dropdown 1000 · sticky 1100 · modal 1300 · toast 1400`

### Suggested Tailwind theme snippet
```ts
// tailwind.config.ts (theme.extend)
colors: { primary: { DEFAULT: '#<hex>', fg: '#FFFFFF' }, /* ... */ },
borderRadius: { sm: '6px', md: '10px', lg: '16px' },
fontFamily: { sans: ['<font>', 'system-ui', 'sans-serif'] },
```

## Components
> For each: anatomy, variants, sizes, and every interaction state
> (default / hover / focus-visible / active / disabled / loading / error).

### Button
- **Variants:** primary, secondary, ghost, destructive
- **Sizes:** sm (32px), md (40px), lg (48px)
- **States:** default · hover · focus-visible (visible ring) · active · disabled · loading
- **A11y:** real `<button>`, `aria-disabled` when loading, min 44px touch target

### Input / Form Field
- Label (always), helper text, error text, required indicator
- States: default · focus · error · disabled · read-only
- A11y: `<label for>`, `aria-invalid`, `aria-describedby` for error/help

### Card · Modal/Dialog · Nav · Table · Toast · Tabs · Avatar · Badge
- <define anatomy, variants, and states per component the product needs>
- Modal: focus trap, `Esc` to close, restore focus, `role="dialog"` + `aria-modal`

## Theming (light / dark)
- Strategy: CSS variables flipped via `class="dark"` on `<html>`.
- All tokens have light + dark values; never hardcode raw hex in components.

## Accessibility & Contrast
| Pairing | Ratio | WCAG AA |
|---------|-------|---------|
| text on bg | <ratio> | ✅ |
| primary-fg on primary | <ratio> | ✅ |
| muted on bg | <ratio> | ✅ (≥4.5 body / ≥3 large) |
- Focus visible on every interactive element; never remove outlines without a replacement.
- Respect `prefers-reduced-motion`.

## Per-screen Visual Direction
> Tie each to the UX screen specs in `docs/design/UX.md`.
- **<Screen>:** layout, key components used, emphasis, responsive behavior
  at 390 / 768 / 1440px.

## Iconography & Imagery
- Icon set: <library>, consistent stroke/size. Imagery style: <describe>.
- No brand logos or third-party trademarked assets.
