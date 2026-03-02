# Drug Overdose Crisis Explorer

Interactive R Shiny dashboard for exploring U.S. drug overdose mortality data from the CDC VSRR Provisional Drug Overdose Death Counts dataset.

**Part of the [Public Health Analytics Playbook](https://andre-inter-collab-llc.github.io/Public-Health-Analytics-Playbook/)**, Chapter 1: The U.S. Drug Overdose Crisis.

## Data Source

- **Dataset**: [VSRR Provisional Drug Overdose Death Counts](https://data.cdc.gov/NCHS/VSRR-Provisional-Drug-Overdose-Death-Counts/xkb8-kh2a) (ID: `xkb8-kh2a`)
- **Publisher**: CDC National Center for Health Statistics (NCHS)
- **Update frequency**: Monthly
- **API**: Socrata Open Data API (no authentication required)

## Features

| Tab | Description |
|:----|:------------|
| **National Overview** | U.S. total overdose death trends by drug category with time series, bar chart, and summary table |
| **State Explorer** | Choropleth map of latest state-level data, state trend comparisons, and filterable data table |
| **Drug Categories** | Compare substance-specific trends (heroin, fentanyl, cocaine, methamphetamine, etc.) for any jurisdiction |
| **State Comparisons** | Head-to-head comparison between two states with overlay trend chart |
| **About** | Data source documentation, ICD-10 codes, and project links |

## Requirements

```r
install.packages(c("shiny", "bslib", "httr2", "jsonlite", "dplyr", "tidyr",
                    "ggplot2", "plotly", "DT", "scales"))
```

## Running the App

From the repository root:

```r
shiny::runApp("apps/shiny/drug-overdose-explorer")
```

Or open `app.R` in RStudio and click **Run App**.

## Notes

- Data is pulled live from the CDC Socrata API on each app launch. An internet connection is required.
- The dataset uses 12-month ending provisional counts (rolling totals), not calendar-year totals.
- A single death may involve multiple substances and appear in more than one drug category.
- Counts below 10 are suppressed by CDC to prevent identification.
- The "Predicted" value type adjusts for reporting delays using NCHS statistical models.

## License

MIT License. See repository root for details.
