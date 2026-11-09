---
name: Fluent Civic Enterprise
colors:
  surface: '#fbf9f8'
  surface-dim: '#dbdad9'
  surface-bright: '#fbf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f3'
  surface-container: '#efeded'
  surface-container-high: '#e9e8e7'
  surface-container-highest: '#e4e2e2'
  on-surface: '#1b1c1c'
  on-surface-variant: '#3f4940'
  inverse-surface: '#303031'
  inverse-on-surface: '#f2f0f0'
  outline: '#6f7a6f'
  outline-variant: '#becabd'
  surface-tint: '#006d37'
  primary: '#006130'
  on-primary: '#ffffff'
  primary-container: '#107c41'
  on-primary-container: '#b6ffc5'
  inverse-primary: '#7ada95'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e4e2e2'
  on-secondary-container: '#646464'
  tertiary: '#1b6033'
  on-tertiary: '#ffffff'
  tertiary-container: '#377949'
  on-tertiary-container: '#b9ffc4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#96f7af'
  primary-fixed-dim: '#7ada95'
  on-primary-fixed: '#00210c'
  on-primary-fixed-variant: '#005228'
  secondary-fixed: '#e4e2e2'
  secondary-fixed-dim: '#c8c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#474747'
  tertiary-fixed: '#acf3b8'
  tertiary-fixed-dim: '#91d69e'
  on-tertiary-fixed: '#00210b'
  on-tertiary-fixed-variant: '#075227'
  background: '#fbf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e4e2e2'
typography:
  display:
    fontFamily: Plus Jakarta Sans
    fontSize: 2.5rem
    fontWeight: '600'
    lineHeight: 3rem
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 1.75rem
    fontWeight: '600'
    lineHeight: 2.25rem
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 1.25rem
    fontWeight: '600'
    lineHeight: 1.75rem
    letterSpacing: -0.01em
  title:
    fontFamily: Plus Jakarta Sans
    fontSize: 1rem
    fontWeight: '600'
    lineHeight: 1.5rem
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.9375rem
    fontWeight: '400'
    lineHeight: 1.375rem
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.875rem
    fontWeight: '400'
    lineHeight: 1.25rem
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.8125rem
    fontWeight: '400'
    lineHeight: 1.125rem
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.8125rem
    fontWeight: '500'
    lineHeight: 1rem
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: 0.875rem
    letterSpacing: 0.02em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 0.75rem
  gutter-lg: 1rem
  margin: 1rem
  margin-lg: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

The design system establishes a high-performance, sober, and structured desktop experience aligned with Windows 11 Fluent Design principles. Designed for civic coordination, community governance, and administrative task execution, the visual language prioritizes utility, efficiency, and clarity over decorative excess.

The aesthetic merges modern desktop ergonomics with deliberate restraint:
- **Tone:** Methodical, trustworthy, authoritative, and tranquil.
- **Visual Direction:** Modern Corporate & Fluent Desktop. Clean light-mode canvases inspired by Mica and Acrylic materials, structured through subtle geometric framing, restrained depth, and crisp stroke boundaries.
- **Restraint:** Eliminates pill badges, heavy drop-shadows, and playful rounded forms. Structural containers maintain discrete visual separation through precise 1px neutral borders and flat neutral elevation layers rather than aggressive color blocks.

## Colors

The palette leverages an architectural grayscale foundation punctuated by an intentional civic emerald accent. Color is used strictly for intent, system status, and focused interactions.

### Canvas & Surface Hierarchy
- **Canvas / App Base (Mica Background):** `#F3F3F3` provides the foundational desktop canvas behind panels and navigation rails.
- **Layer 1 Surface (Secondary Container):** `#F9F9F9` serves as the sub-surface for navigation panels, side rails, and grouped sections.
- **Layer 2 Surface (Primary Card / Window):** `#FFFFFF` provides clean contrast for focal content, work tables, and interactive card modules.
- **Surface Borders & Dividers:** Crisp boundaries are enforced with `#E5E5E5` for standard division and `#D1D1D1` for interactive element outlines.

### Text & Foregrounds
- **Primary Text:** `#1F1F1F` (high contrast, high legibility for critical data).
- **Secondary Text:** `#5C5C5C` (metadata, helper text, and column headers).
- **Disabled Text / Low-emphasis:** `#8D8D8D`.

### Accent & Feedback
- **Primary Accent (`#107C41`):** Reserved strictly for primary action buttons, focused input highlights, critical step progress bars, and validated states.
- **Accent Hover / Pressed:** `#0E6B37` (hover) and `#0B542B` (pressed).
- **Subtle Accent Wash (`#E9F5ED`):** Used sparingly for selected table rows or focused navigation pills.
- **System States:** Red (`#C42B1C`) for destructive actions and warnings; Amber (`#9D5D00`) for pending approvals; Emerald (`#107C41`) for confirmed resolutions.

## Typography

The typographic hierarchy aligns with native Windows desktop standards: compact, dense, legible, and balanced. Plus Jakarta Sans provides clean geometry, high x-height, and open counters suitable for desktop grid layouts and dense data displays.

- **Scale Behavior:** Information density is preferred over oversized display type. The maximum desktop view headline settles at 28px (`headline-lg`), while main section headers use 20px (`headline-md`).
- **Hierarchy Enforcement:** Headers communicate grouping without decorative badge tags. Bold weights (`600`) paired with subtle neutral dividers isolate content sections cleanly.
- **Numeric & Data Values:** High-density metric cards utilize tabular figures to maintain vertical alignment across financial values, protocol counters, and citizen registration IDs.

## Layout & Spacing

The layout follows a multi-pane desktop shell model characterized by an App Navigation Rail (48px collapsed or 240px expanded), an optional List/Master Pane (280px-320px), and a Fluid Detail Work Area.

### Structure & Rhythm
- **8px Base Grid:** Layout distances conform strictly to multiples of 4px and 8px to mirror desktop window managers.
- **Component Padding:** Compact paddings (`space-sm` at 8px, `space-md` at 12px) preserve screen real estate, allowing high information density without visual crowding.
- **Section Grouping:** Functional zones are partitioned using 12px and 16px element gaps, ensuring related controls form cohesive clusters.
- **Margins & Gutters:** Global window padding remains locked at 16px to 24px, maintaining standard desktop gutter alignment against window frame edges.

## Elevation & Depth

Visual hierarchy uses Windows 11-style tonal layering combined with low-contrast structural outlines rather than heavy drop shadows.

### Layering Rules
- **Base Canvas:** `#F3F3F3` sits at Z-0.
- **Side Panels / Rails:** `#F9F9F9` at Z-1 with a 1px border (`#E5E5E5`) along the right edge.
- **Cards & Data Grids:** Pure white (`#FFFFFF`) at Z-2, bounded by a continuous 1px outline of `#E5E5E5` and a subtle directional contact shadow (`0 1px 2px rgba(0, 0, 0, 0.04)`).
- **Flyouts, Dropdowns & Context Menus:** Z-3 elevated surfaces (`#FFFFFF`) with a 1px stroke of `#D1D1D1` and dual-stage Fluent elevation: `0 4px 8px rgba(0, 0, 0, 0.06), 0 0 2px rgba(0, 0, 0, 0.08)`.
- **Modals / Dialogs:** Centered Z-4 surface (`#FFFFFF`) accompanied by a 24% black smoke scrim (`rgba(0, 0, 0, 0.24)`), framed with a 1px stroke of `#CCCCCC` and an elevation shadow of `0 16px 32px rgba(0, 0, 0, 0.12)`.

## Shapes

The design system enforces standard Windows 11 corner geometry. Elements use modest, structural radii between 4px and 8px. Oval pills and fully rounded circular forms are avoided.

- **Small Components (Buttons, Input Fields, Checkboxes, Dropdowns):** `4px` corner radius (`rounded-sm`).
- **Standard Surfaces (Cards, Tables, Command Bars, Info Banners):** `6px` corner radius.
- **Top-Level Windows & Dialogs:** `8px` corner radius (`rounded-lg`).
- **Status Tags / Category Badges:** Rectangular with `4px` radius; never capsule or pill-shaped.

## Components

### Buttons
- **Primary Action:** Solid background (`#107C41`), text `#FFFFFF`, border `1px solid #0E6B37`, corner radius `4px`. Height: 32px for desktop density. Hover: `#0E6B37`. Active: `#0B542B`.
- **Standard (Neutral):** Background `#FFFFFF`, text `#1F1F1F`, border `1px solid #D1D1D1`, radius `4px`. Hover: background `#F9F9F9` and border `#BEBEBE`.
- **Subtle / Ghost:** Background `transparent`, text `#1F1F1F`. Hover: background `#ECECEC`. Used in title bars and command toolbars.

### Input Fields & Selects
- Height: 32px.
- Background: `#FFFFFF`. Border: `1px solid #D1D1D1` with a bottom highlight affordance.
- Border radius: `4px`.
- Focus state: `1px solid #D1D1D1`, bottom border reinforced with a 2px active indicator in `#107C41`.

### Cards & Data Panels
- Surface: `#FFFFFF`.
- Border: `1px solid #E5E5E5`.
- Radius: `6px`.
- Padding: 12px inner content padding for compact layout; 16px for summaries.
- Header: Subtle horizontal divider (`1px solid #F0F0F0`) separating card header from content body.

### Checkboxes & Radio Controls
- Size: 16px x 16px.
- Corner radius: `3px` for checkboxes; full circle only for native radio inputs.
- Border: `1px solid #8D8D8D`. Checked state: background `#107C41`, border `#107C41`, white check icon.

### Status Indicators & Badges
- Form factor: Compact rectangular indicators with `4px` corner radius, 20px fixed height, 6px horizontal padding.
- Color treatment: Neutral background `#F3F3F3` with a 1px border `#E0E0E0` and a 6px solid colored circular dot on the left side to signal status (e.g., `#107C41` for active, `#9D5D00` for under review).

### Data Tables
- Row height: 36px (compact desktop density).
- Header row: `#F9F9F9`, uppercase label typography (`label-sm`), border bottom `1px solid #E0E0E0`.
- Row hover: `#F6F6F6`. Selected row: `#E9F5ED` with a 3px vertical accent bar on the left edge in `#107C41`.