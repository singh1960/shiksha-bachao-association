# Shiksha Bachao Association — Release Master Index

**Release status:** Stable / Release-Ready Foundation  
**Audit date:** 23 September 2026 (Final Repository / Release Audit)  
**Repository:** `singh1960/shiksha-bachao-association`  
**Branch:** `main`  
**Website:** https://singh1960.github.io/shiksha-bachao-association/

## 1. Stable Foundation

This document records the repository state after the final cleanup and welfare-form release work. The current structure should be treated as the baseline for future development.

### Baseline rules
1. Make only targeted changes.
2. Do not redesign or restructure existing pages unless a concrete requirement is approved.
3. Before editing an existing file, fetch the latest version and verify its current content.
4. After every write, re-fetch the changed file and verify the result.
5. Prefer one logical change per commit.
6. Do not delete files merely because they look old; first verify that they are unused.
7. Keep `welfare-scheme.html` as the single authoritative entry point for the 30 welfare forms.
8. Do not recreate the three obsolete welfare PDFs that were removed during the final cleanup.
9. Preserve the three-language structure: Hindi, English and Marathi.
10. Run a link/reference audit after significant navigation or file changes.

## 2. Current Repository Snapshot

The final repository audit recorded **56 tracked files**.

### Core website pages
- `index.html` — Main website/home page
- `about-us-professional.html` — Primary About Us page
- `about-us.html` — Legacy/compatibility redirect to the professional About Us page
- `downloads-forms.html` — Downloads and Forms entry page
- `membership.html` — Membership information/application
- `welfare-scheme.html` — Authoritative Teacher Welfare Scheme and all 30 welfare-form links
- `welfare-benefits.html` — Detailed welfare assistance information
- `eligibility.html` — Eligibility information
- `education-court-orders.html` — Education/legal orders information
- `government-schemes.html` — Government schemes
- `government-updates.html` — Government updates

### Welfare Forms
Directory: `welfare-forms/`

**Hindi — 10**
- HI-WF-01.html
- HI-WF-02.html
- HI-WF-03.html
- HI-WF-04.html
- HI-WF-05.html
- HI-WF-06.html
- HI-WF-07.html
- HI-WF-08.html
- HI-WF-09.html
- HI-WF-10.html

**English — 10**
- EN-WF-01.html
- EN-WF-02.html
- EN-WF-03.html
- EN-WF-04.html
- EN-WF-05.html
- EN-WF-06.html
- EN-WF-07.html
- EN-WF-08.html
- EN-WF-09.html
- EN-WF-10.html

**Marathi — 10**
- MR-WF-01.html
- MR-WF-02.html
- MR-WF-03.html
- MR-WF-04.html
- MR-WF-05.html
- MR-WF-06.html
- MR-WF-07.html
- MR-WF-08.html
- MR-WF-09.html
- MR-WF-10.html

**Total: 30 forms (10 + 10 + 10).**

## 3. Supporting Assets and Data

Important retained supporting files include:
- `banner-hindi.png`
- `banner-english.png`
- `banner-marathi.png`
- `robots.txt`
- `sitemap.xml`
- `education-candidates.json`
- `education-updates.json`
- `.github/workflows/education-updates.yml`
- `Shiksha_Bachao_Association_Membership_Application_Form_FIXED.pdf`
- `Nominee_Forms_Hindi_English_Marathi.zip`
- `Complaint_Suggestion_Forms_Hindi_English_Marathi.zip`

## 4. Navigation Architecture

The intended user flow is:

**Main Page → Downloads & Forms → Teacher Welfare Scheme → Language → Individual Welfare Form**

The 30 welfare forms have one authoritative listing location:
**`welfare-scheme.html`**

The Downloads page provides one welfare entry point per language and does not duplicate the 30 individual form links.

## 5. Final Audit Results

| Check | Result |
|---|---|
| Tracked repository files | 56 |
| Hindi welfare forms | 10 |
| English welfare forms | 10 |
| Marathi welfare forms | 10 |
| Total welfare forms | 30 |
| Direct welfare-form references in welfare-scheme.html | 30 |
| Direct welfare-form references in downloads-forms.html | 0 |
| Obsolete welfare PDF references | 0 |
| Obsolete welfare PDFs remaining | 0 |
| Sitemap obsolete-PDF references | 0 |
| Public `Version 1.3` labels on audited welfare pages | 0 |
| Welfare guidance/submission pages included in sitemap | Yes |
| Robots.txt obsolete-PDF references | 0 |

## 6. Cleanup Record

The following obsolete single-page welfare PDFs were confirmed unused and removed:
- `Teachers_Welfare_Assistance_Form_Hindi_Corrected_v2.pdf`
- `Teachers_Welfare_Assistance_Form_English_Clear.pdf`
- `Teachers_Welfare_Assistance_Form_Marathi_Corrected_v2.pdf`

Cleanup commits:
- `eee16e2a6cc5fd7516256318b079de1e75cf641f`
- `0c70210bc01e15f87550f53d2e009b0066201a81`
- `a5d90a2d4f2a210cc2faff24874934e7ae3d85fd`

Other key stabilization commits:
- `12adc2f581bbe50ddb13b54275b393918c6e2f88` — removed duplicate welfare listings
- `f919ea151fc8e2fa0dfe28b621d6d0aa4adafe74` — removed obsolete welfare PDF links
- `0ab87a638e72a6cecf9a0cfe04e3bc94be03ff3a` — simplified welfare headings
- `07e455dcb04578b1084dd97c21529d09198e52e1` — fixed Downloads & Forms language display

## 7. Release Baseline

The following areas are considered **stable and should not be unnecessarily modified**:
- Existing main-page structure
- Three-language welfare navigation
- 30 Version 1.3 welfare-form files
- Welfare form entry architecture
- Existing membership/nominee/complaint downloads
- Existing banners and core assets
- Sitemap and robots configuration

Future work should build on this baseline rather than replacing it.

## 8. Next Development Areas

Development should proceed in this order:
1. Documentation and change-control
2. Welfare guidance / FAQ
3. Online forms and submission workflow
4. Teacher Survey 2026
5. Education and legal information resources
6. Search and navigation improvements
7. Accessibility and SEO
8. Performance and technical audit
9. Advanced member/admin features

## 9. Definition of Stable

A future change may be considered stable only after:
- the intended file(s) are identified;
- the current file version is fetched;
- the change is limited to the approved scope;
- links/references are checked;
- the changed file is re-fetched;
- the commit is recorded;
- no unrelated structure has been changed.

---
**Document purpose:** permanent internal release reference for future development and maintenance.
