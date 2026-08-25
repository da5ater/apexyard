# SASSY

**Repo**: https://github.com/da5ater/Sassy
**Workspace**: workspace/sassy/
**Docs**: projects/sassy/
**Status**: active (greenfield — repo initialized, no code yet)
**Tier**: P1

## What it is

SASSY is a managed marketplace for deployable ecommerce solutions. A buyer
browses ready-made ecommerce blueprints, previews a demo, pays, and gets a live
hosted store quickly — SASSY owns provisioning, hosting, domains, SSL, monitoring,
and rollback rather than leaving the buyer to assemble infrastructure. The founding
wedge is **managed fulfillment + runtime standardization** (the App Store's
submission/review/versioning mechanics over Amazon's narrow-category marketplace
ambition), not a buyer-side discovery play.

V1 is deliberately narrow: one opinionated MERN-based commerce blueprint
(Clothing Commerce Starter), first-party supply only, SASSY-hosted on Railway,
per-buyer isolated deployed instances. Marketplace expansion, broader blueprint
families, and deeper trust/governance come in later versions after the core
fulfillment loop is proven.

## Who owns it

- **Tech Lead**: @da5ater
- **Product**: @da5ater
- **Stakeholders**: (TBD)

## Tech stack

- Backend: Node.js + Express modular monolith, Prisma + PostgreSQL
- Frontend: React (separate app, role-aware: buyer / seller / operator)
- Runtime: Railway (V1 provider, behind a SASSY-owned adapter boundary)
- Auth: HTTP-only session cookies, backend-enforced roles (buyer/seller/operator/root)

## Key links

- Repo: https://github.com/da5ater/Sassy
- Discovery docs (baseline snapshot): ./discovery/
- Design doc (rehomed): ./discovery/source-v1-design.md
- PRD (rehomed): ./discovery/source-prd.md

## Recent activity

- 2026-08-25: Registered in portfolio. Rehomed existing v1 design/PRD/research
  docs into `discovery/` as the shaping baseline. Shaping pipeline pending
  (`/grilling` → `/shaping` → `/design-review` → `/plan-initiative`).
