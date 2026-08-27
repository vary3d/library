# Vary3D Library

Parametric OpenSCAD in the browser — change numbers, export STL / 3MF.

Play these models on **[vary3d.com](https://vary3d.com)**. This repository is the Git source for the official catalog (`@vary3d-library` on the site).

> Not our designs. Playable versions of open parametric work, with attribution. Make your size.

## What this is

A catalog of **playable OpenSCAD models**: source, Customizer parameters, and named presets so you can fit a part to your printer or desk without rewriting the code.

Each entry is a curated fork of permissively licensed work (MIT, Apache, CC-BY, CC0, or public domain). We add packaging and official presets. We do not rebrand upstream authors as Vary3D.

## What this is not

- Not the Vary3D website, account system, or runtime
- Not an STL / 3MF file dump — geometry is generated in the browser
- Not an OpenSCAD *include* library (that is BOSL2, MCAD, and similar)
- Not a place to upload models for you — publish on [vary3d.com](https://vary3d.com)
- Not original CAD from Vary3D except where `ORIGIN.md` says so

## Layout

One directory per model:

```text
packages/<slug>/
  model.scad        # entry file
  info.json         # listing (format: vary3d.info)
  variants.json     # official presets (when there are ≥2 useful sets)
  LICENSE           # upstream license, unmodified
  ORIGIN.md         # Forked from URL, original author, what we changed
```

`info.json` uses `"format": "vary3d.info"`. `variants.json` uses `"format": "vary3d.variants"`. Field docs will live in `vary3d/spec` when that repo is published.

## License and attribution

- **Packaging** in this repository (README, catalog scripts we write) is for Vary3D to choose a permissive license (MIT or Apache-2.0) when we add a root `LICENSE`.
- **Each model** keeps its **upstream `LICENSE` verbatim**. Do not replace it with a Vary3D copyright.
- Every public model must have `ORIGIN.md` with Forked from, original author, and a short note of what this catalog changed (presets, Customizer comments, listing text — not a claim of original design).
- We do not accept NC, ND, GPL, unclear licenses, or “download only” files into the public catalog.

On the site, the same facts show as **Forked from** / license on the model page.

## Using the models

1. Open the matching listing on [vary3d.com](https://vary3d.com) (Library filter).
2. Drag parameters, pick an official preset if you want, export STL or 3MF.
3. To work from git: clone this repo and open `packages/<slug>/model.scad` in OpenSCAD or in Vary3D Playground.

No install is required to customize on the site. The in-browser runtime is VarySCAD (Manifold mesh + WebGL preview). That engine is not sourced from this repository.

## Status

This catalog is being filled as each model’s license and origin are checked. Empty `packages/` means nothing has passed that bar yet.

## Issues

Use Issues for **catalog packaging and format** (missing `ORIGIN.md`, broken `info.json`, bad presets).

Do not file site bugs, accounts, payments, or moderation here.

## Security

Report vulnerabilities by email to **security@vary3d.com**. Do not open a public issue with a proof of concept.
