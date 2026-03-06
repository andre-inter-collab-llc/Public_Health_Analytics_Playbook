````instructions
# Copilot Instructions for Public Health Analytics Playbook

## Project Overview

**Public Health Analytics Playbook** is an open-source Quarto Book that explores real public health issues through reproducible data analysis. Each chapter tackles a specific public health problem, walks through publicly available data sources, and provides working R and Python code that readers can adapt for their own analyses. It is published to GitHub Pages.

- **Public repository**: <https://github.com/andre-inter-collab-llc/Public_Health_Analytics_Playbook>
- **Published book**: <https://andre-inter-collab-llc.github.io/Public-Health-Analytics-Playbook/>

### Core Philosophy

- **Issue-driven chapters**: Each chapter focuses on a specific public health issue (e.g., drug overdose crisis, maternal mortality, climate and health). Chapters are organized by issue, not by jurisdiction. Geographic comparisons happen *within* chapters where relevant.
- **Playbook pattern**: Every chapter follows the same four-part structure: The Issue, The Data, The Analysis, The Visualizations. This makes the book both an exploration and a reusable template.
- **Evidence-based content**: All claims are grounded in published epidemiological data, official statistics, and documented financial records. No speculation.
- **Reproducible code**: Every analysis must be reproducible using documented data sources, public APIs, and open-source tools (R, Python). Code blocks are the core deliverable.
- **Local-first execution**: Prioritize solutions that run on local machines using open tools.
- **Public-good publishing**: Analyses are designed to be freely accessible and useful for researchers, analysts, students, and advocates.
- **Author Persona**: Content reflects André van Zyl's dual expertise (Epidemiologist & Data Scientist). Use **first-person voice** for personal sections (About the Author, Preface) and professional/instructional tone for chapter content.
- **Development Tools Separation**: The tools used to *build* this book (VS Code, GitHub Copilot, Quarto, Mermaid) should not be referenced in the main content; they are documented in Appendix B only.

### Companion Projects

This project is complementary to, but separate from:

- **[Public Health Automation Clinic](https://andre-inter-collab-llc.github.io/Public-Health-Automation-Clinic/)**: Practical automation solutions for public health workflows
- **[Bridgeframe Toolkit](https://andre-inter-collab-llc.github.io/Bridgeframe-Toolkit/)**: Bridging business analysis and public health terminology and practice
- **Automating Public Health Analytics**: Internal analytics automation project

Do not duplicate content from these projects. Cross-reference them where appropriate.

## Book Structure

**Project Type**: Quarto Book published to GitHub Pages with MS Word download option.

### Front Matter
- **Cover/Index** (`index.qmd`): Book landing page with welcome, the playbook pattern, audience, and companion project links.
- `index.qmd` is the **only place** that lists target audiences ("Who This Is For"). Chapter content should not duplicate this.

### Analyses (issue-based chapters)
Chapters are numbered sequentially and named by issue:
- `chapters/01-drug-overdose-crisis.qmd`: The U.S. Drug Overdose Crisis

New chapters are added as new issues are explored. Examples of future chapters:
- Maternal mortality
- Diabetes in Indian Country
- Climate-driven health impacts
- HIV/TB dual burden in sub-Saharan Africa
- Mental health and suicide prevention

### Appendices
- **B: Development Tools** (`chapters/B-development-tools.qmd`): Tools used to build the book. Documented for transparency only.
- **C: Glossary** (`chapters/C-glossary.qmd`): Key terms for epidemiology, data science, and health financing. **Always the last appendix in the book.**

### Adding a New Chapter
1. Create `chapters/XX-descriptive-name.qmd` with YAML frontmatter containing a `title` field.
2. Follow the four-part playbook pattern (Issue, Data, Analysis, Visualizations).
3. Add the file to `_quarto.yml` under the "Analyses" part.
4. Update the glossary with any new domain terms introduced.
5. Add new bibliography entries to `assets/references/references.bib`.

## Repository Structure

```
Public_Health_Burden_to_Budget/        # (will be renamed to Public_Health_Analytics_Playbook)
├── _quarto.yml               # Book configuration (chapters, output formats, theme)
├── _brand.yml                 # Intersect Collaborations branding (colors, fonts, logo)
├── index.qmd                  # Book landing page / welcome
├── README.md
├── LICENSE
├── .nojekyll
├── .gitignore
├── .github/
│   ├── copilot-instructions.md
│   └── workflows/
│       └── publish.yml        # GitHub Actions workflow for auto-deployment
├── assets/
│   ├── branding/
│   │   ├── logos/             # Intersect Collaborations logos
│   │   ├── icons/             # Favicon and app icons
│   │   ├── images/            # Cover image and other branded graphics
│   │   └── templates/
│   │       └── IntersectCollab-reference-doc.docx  # Word export template
│   ├── references/
│   │   ├── references.bib     # Bibliography in BibTeX format
│   │   └── apa.csl            # Citation Style Language (APA 7th)
│   └── styles/
│       └── custom.scss        # Custom SCSS extending _brand.yml
├── chapters/                  # Book chapters (.qmd files, one per issue)
│   ├── 01-drug-overdose-crisis.qmd
│   ├── B-development-tools.qmd
│   └── C-glossary.qmd
├── data/                      # Downloaded datasets (organized by chapter/issue)
├── analysis/                  # Standalone R/Python scripts (organized by chapter/issue)
├── apps/                      # Interactive dashboards
│   ├── shiny/                 # R Shiny applications
│   └── tableau/               # Tableau Public workbooks
├── library/                   # Research reference materials (source docs, not published)
├── admin/                     # Local internal only; not committed/published
│   ├── communications/        # LinkedIn posts, outreach drafts
│   ├── scripts/               # Development scripts
│   └── notes/                 # Research notes, planning documents
└── _book/                     # Generated output (in .gitignore)
```

## Privacy and Handling Rules

- Treat everything in `admin/` as internal development context.
- Do not commit `admin/` files to GitHub and do not include them in public site publishing.
- `admin/` content should only be backed up to `GDRIVE_DEST=G:\My Drive\Intersect_Collaborations_LLC\04_projects\Public-Health-Analytics-Playbook`.
- Treat `publish.bat` as internal operational tooling; do not surface it in public-facing documentation.
- Treat `library/` research files as source reference material; do not publish them directly. Synthesize and cite their content in chapters.

## Publishing Model

- Local render: `quarto render`
- Local preview: `quarto preview`
- GitHub Pages publish: handled by `.github/workflows/publish.yml`
- Output directory: `_book/`

### GitHub Actions Workflow

The `.github/workflows/publish.yml` handles automated deployment. On push to `main`, the workflow:
1. Checks out the repository
2. Sets up Quarto
3. Renders and publishes to `gh-pages` branch

### Key Files for Publishing
- `.nojekyll`: Prevents GitHub from processing with Jekyll
- `.github/workflows/publish.yml`: GitHub Actions workflow
- `_publish.yml`: Created by first `quarto publish` run (if used)
- `_freeze/`: Stores computation results (commit to version control if present)

## Authoring and Editing Standards

### File Types
- Use `.qmd` for chapter-like content and any content that may include code execution or citations.
- Use `.md` for communications and operational docs.
- Use `.R` and `.py` for analysis scripts in the `analysis/` folder.

### YAML Frontmatter
Every `.qmd` file must begin with YAML frontmatter containing at minimum a `title` field:
```yaml
---
title: "Page Title Here"
---
```

### Heading Hierarchy
- The first content heading in each document must use a single `#` (Heading 1).
- Do not manually number headings. Quarto's `number-sections: true` setting handles automatic numbering for HTML output.

### Writing Style
- Keep language clear, analytical, and evidence-based.
- Ground all claims in cited data sources. Do not make unsupported assertions about health outcomes or spending.
- Use epidemiological terminology precisely (incidence vs. prevalence, mortality rate vs. case fatality rate).
- Include working external links when referencing data sources, organizations, tools, or standards.
- Avoid adding unnecessary architecture or product features beyond the stated scope.
- **No Dashes for Punctuation**: Never use em dashes (—) or en dashes (–) in content. Rewrite sentences to use commas, colons, semicolons, or parentheses instead.

### Hyperlinks and External References
When mentioning organizations, data portals, tools, or external resources, **include hyperlinks** to the relevant websites:
- **Data Portals**: Link to the specific portal or API documentation page.
- **Organizations**: Link to main website or relevant subpage.
- **Tools and Software**: Link to the product or documentation page when first mentioned in a chapter.
- **Standards and Frameworks**: Link to the authoritative source.
- **Format**: Use standard Markdown link syntax: `[Display Text](URL)`. Prefer HTTPS URLs.
- **Maintenance**: When updating content, verify that existing hyperlinks remain valid.

### Citation Style
Leverage the Quarto bibliography system configured in `_quarto.yml`:
- **Format**: Use standard Pandoc citation syntax: `[@citationKey]` or `@citationKey`.
- **Source**: Keys must match entries in `assets/references/references.bib`.
- Add new references to `references.bib` as chapters are developed.

### Glossary Maintenance
When creating or updating chapters, **always update the glossary** (`chapters/C-glossary.qmd`) to include any new domain-specific terms introduced in the content.

**For each new term, include:**
- The term in bold with its domain context
- A definition list entry (`: ` syntax) with clear explanation
- Cross-references to related terms where applicable

### Content Deduplication Rules
- **"Who This Is For"** lives only in `index.qmd`. Do not repeat the audience list in chapter content.
- **Data sources** are documented inline within each chapter where they are used. There is no centralized data source inventory chapter.

## Technical Standards

### Diagrams (Mermaid)
- Use `flowchart LR` for data pipeline flows (Source → Ingestion → Transform → Analysis → Output).
- Use `flowchart TD` for analytical frameworks.
- Use `graph TD` for system architecture diagrams.

### Code (R and Python)
- **R Style**: Modern `tidyverse` conventions. Use `ggplot2` for static visualizations, `plotly` for interactive charts, `sf` for spatial data, `httr2` for API access.
- **Python Style**: Standard library + `pandas`, `requests`, `pdfplumber`, `tabula-py` for data extraction.
- **Context**: Use real epidemiological examples (mortality rates, DALY comparisons, expenditure time series) in all code.
- **Reproducibility**: All scripts must include source URLs, date accessed, and version information for data sources.

### Interactive Dashboards
- **R Shiny**: Place application code in `apps/shiny/[app-name]/`. Each app should be self-contained with its own `app.R` or `ui.R`/`server.R`.
- **Tableau Public**: Document workbook details in `apps/tableau/`. Include the Tableau Public URL for published dashboards.
- **Embedded Dashboards**: Use `<iframe>` with the `.dashboard-embed` CSS class for embedded visualizations in chapters.

### Data Handling
- **Raw Data**: Store downloaded datasets in `data/`. Organize by chapter or issue topic, not by jurisdiction.
- **Processed Data**: Analysis scripts in `analysis/` should read from `data/` and produce outputs used in chapters.
- **Sensitive Data**: Never commit or publish data that could identify individuals. All analyses use aggregated, publicly available data unless formal DUAs are in place.
- **Data Sovereignty**: When working with Indigenous population data (e.g., Navajo Nation), use only publicly available aggregated reports unless formal tribal approvals exist. Acknowledge data sovereignty principles.

## Branding Configuration

The book uses Intersect Collaborations branding via `_brand.yml` for unified appearance across HTML and downloadable formats. This is the same branding used across all Intersect Collaborations projects (Bridgeframe Toolkit, Public Health Automation Clinic).

### Brand Elements

**Color Palette** (from company logo):
- Blue `#2494f7`: Main brand color
- Teal `#00a4bb`: Accent color
- Navy `#01272f`: Dark backgrounds
- Dark `#020506`: Text on light backgrounds
- Slate `#204d70`: Secondary text

**Typography**:
- Base: Inter (Google Fonts)
- Headings: Inter, weight 800
- Monospace: Fira Code (Google Fonts)

### Logo Files Required
Place in `assets/branding/` (copy from companion projects):
- `logos/intesect_logo_v1.png`: Main logo for navbar/title page
- `icons/intesect icon v1.png`: Browser tab icon
- `images/cover-image.jpg`: Cover image for the book
- `templates/IntersectCollab-reference-doc.docx`: Word export template

### Supported Output Formats
- **HTML**: Full brand support (colors, fonts, logo in navbar)
- **MS Word (docx)**: Uses `IntersectCollab-reference-doc.docx` as reference document for styles

## Content Patterns

### Chapter Playbook Pattern
Every analysis chapter should follow this consistent four-part structure:

1. **The Issue**
   - What is the public health problem? Scale, trends, context.
   - Why does it matter? Mortality, morbidity, equity implications.
   - Geographic and demographic variation.

2. **The Data**
   - What datasets are available? (CDC WONDER, Socrata open data, WHO GHO, etc.)
   - Access methods: API endpoints, download portals, query systems.
   - Limitations: suppression rules, lag times, coverage gaps.

3. **The Analysis**
   - Reproducible R and/or Python code to pull and analyze the data.
   - Working API calls with real endpoints and parameters.
   - Data wrangling, transformation, and summary statistics.

4. **The Visualizations**
   - `ggplot2` or `plotly` charts showing trends, comparisons, distributions.
   - Tables summarizing key metrics.
   - Maps where geographic variation is relevant.

Each chapter should also end with a **"Questions for Further Analysis"** section suggesting logical extensions.

### Callout Box Patterns
Use callout boxes consistently:

```markdown
::: {.callout-note title="Data Source"}
[Document the specific data source and access method for a given analysis]
:::

::: {.callout-warning title="Data Access Constraint"}
[Document restrictions on data access, suppression rules, or DUA requirements]
:::

::: {.callout-important title="Data Sovereignty"}
[Document tribal data sovereignty considerations]
:::

::: {.callout-tip title="Reproducibility"}
[Document how to reproduce a specific analysis, including code, data source, and parameters]
:::
```

## Communications Guidance

The `admin/communications/` folder contains LinkedIn posts and outreach content. This content is **separate from the book** and not included in the Quarto build.

### Content Guidelines
When editing posts and outreach content:
- Emphasize the playbook approach: real issues, real data, real code
- Highlight reproducibility and open data access
- Reference specific findings from the book
- Maintain clear, evidence-based tone
- **Tone**: Authoritative, data-driven, accessible. "Thought Leader" voice.
- **Hashtags**: #PublicHealth #Epidemiology #HealthFinancing #DataScience #GlobalHealth #HealthEquity #OpenData #RStats #Python #PublicHealthData

## Development Scripts

The `admin/scripts/` folder contains scripts used for building and maintaining the project (e.g., data extraction prototyping, asset generation) that are **not part of the published book**. These are internal development tools only.

- Keep scripts local-only under `admin/scripts/` and exclude them from public publication.
- Do not place development scripts alongside app source code in `apps/`; app folders should contain only the deliverable application.
````
