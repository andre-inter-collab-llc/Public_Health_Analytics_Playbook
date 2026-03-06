# =============================================================================
# Drug Overdose Crisis Explorer - ui.R
# Full-width layout with on-demand data loading and in-page navigation.
# =============================================================================

# -- helper: scroll-to button --
scroll_btn <- function(target_id, label) {
  tags$a(label, href = "#", class = "btn btn-sm btn-outline-secondary",
         onclick = paste0(
           "document.getElementById('", target_id,
           "').scrollIntoView({behavior:'smooth'});return false;"))
}

# -- helper: load-data landing card --
load_card <- function(icon_name, heading, description, btn_id) {
  div(
    class = "d-flex justify-content-center align-items-center",
    style = "min-height: 65vh;",
    card(
      class = "text-center p-5 shadow", style = "max-width: 600px;",
      icon(icon_name, class = "fa-3x text-primary mb-3"),
      tags$h4(heading),
      tags$p(class = "text-muted", description),
      actionButton(btn_id, "Load Data",
                   class = "btn-primary btn-lg mt-3", icon = icon("download"))
    )
  )
}

# -- helper: section download header --
dl_header <- function(title, btn_id) {
  card_header(
    class = "d-flex justify-content-between align-items-center",
    title,
    downloadButton(btn_id, "Download Excel",
                   class = "btn-sm btn-outline-primary")
  )
}

# =============================================================================
ui <- page_navbar(
  title = tags$span(
    tags$img(src = "logo.png", height = "32px", class = "me-2"),
    tags$strong("Drug Overdose Crisis Explorer"),
    style = "font-family: 'Inter', sans-serif;"
  ),
  id = "main_nav",
  header = tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png")),
  theme = bs_theme(
    version = 5, bootswatch = "flatly",
    primary = brand$blue, secondary = brand$teal,
    bg = brand$white, fg = brand$dark,
    base_font = font_google("Inter"),
    heading_font = font_google("Inter"),
    code_font = font_google("Fira Code"),
    "navbar-bg" = brand$navy
  ),
  navbar_options = navbar_options(bg = brand$navy, theme = "dark"),

  # =========================================================================
  # Tab 1: CDC Overdose Mortality
  # =========================================================================
  nav_panel(
    title = "Overdose Mortality", icon = icon("chart-line"),

    # --- Load button ---
    conditionalPanel(
      condition = "!output.cdc_ready",
      load_card("chart-line", "CDC Overdose Mortality Data",
                "Provisional drug overdose death counts from CDC VSRR, by state and drug category.",
                "load_cdc_btn")
    ),

    # --- Content (shown after data loads) ---
    conditionalPanel(
      condition = "output.cdc_ready",

      # Filters
      card(
        card_header(tags$strong(icon("filter"), " Filters"), class = "bg-light"),
        card_body(
          class = "py-2",
          fluidRow(
            column(4, selectizeInput("cdc_indicator", "Drug Category",
                                     choices = NULL, multiple = TRUE,
                                     options = list(placeholder = "Select categories..."))),
            column(4, sliderInput("cdc_years", "Year Range",
                                  min = 2015, max = 2026, value = c(2015, 2026),
                                  step = 1, sep = "", ticks = FALSE)),
            column(4,
              radioButtons("cdc_value_type", "Death Count Type",
                           choices = c("Reported" = "data_value",
                                       "Predicted (adjusted)" = "predicted_value"),
                           selected = "data_value", inline = TRUE)
            )
          )
        )
      ),

      # In-page navigation
      tags$div(
        class = "d-flex flex-wrap gap-2 my-3 p-2 bg-light rounded shadow-sm",
        scroll_btn("cdc-trend", "National Trend"),
        scroll_btn("cdc-map", "State Map"),
        scroll_btn("cdc-drugs-bar", "Drug Categories"),
        scroll_btn("cdc-drugs-area", "Drug Trends"),
        scroll_btn("cdc-table", "Data Table")
      ),

      # Visualizations
      div(id = "cdc-trend",
        card(card_header("12-Month Ending Provisional Drug Overdose Deaths by Jurisdiction"),
             card_body(plotlyOutput("cdc_national_trend", height = "750px")))
      ),
      div(id = "cdc-map",
        card(card_header("State Choropleth Map (Latest Period)"),
             card_body(plotlyOutput("cdc_state_map", height = "650px")))
      ),
      div(id = "cdc-drugs-bar",
        card(card_header("Latest 12-Month Totals by Drug Category"),
             card_body(plotlyOutput("cdc_drug_bar", height = "650px")))
      ),
      div(id = "cdc-drugs-area",
        card(card_header("Drug Category Trends Over Time"),
             card_body(
               plotlyOutput("cdc_drug_area", height = "750px"),
               tags$div(class = "alert alert-info mt-2 small", role = "alert",
                 icon("circle-info"),
                 " Note: These four drug categories are not mutually exclusive. A single ",
                 "death may involve multiple substances and appear in more than one category. ",
                 "Stacked totals therefore overcount the number of unique deaths."
               )
             )
        )
      ),
      div(id = "cdc-table",
        card(dl_header("CDC Overdose Data", "cdc_download_xlsx"),
             card_body(DTOutput("cdc_data_table")))
      )
    )
  ),

  # =========================================================================
  # Tab 2: Federal Funding (USAspending)
  # =========================================================================
  nav_panel(
    title = "Federal Funding", icon = icon("dollar-sign"),

    conditionalPanel(
      condition = "!output.funding_ready",
      load_card("dollar-sign", "Federal Funding Data",
                "Opioid-related federal grant awards from USAspending.gov.",
                "load_funding_btn")
    ),
    conditionalPanel(
      condition = "output.funding_ready",
      tags$div(
        class = "d-flex flex-wrap gap-2 my-3 p-2 bg-light rounded shadow-sm",
        scroll_btn("funding-summary", "Summary"),
        scroll_btn("funding-by-agency", "Funding by Agency"),
        scroll_btn("funding-timeline", "Timeline"),
        scroll_btn("funding-wc", "Word Cloud"),
        scroll_btn("funding-tbl", "Data Table")
      ),
      div(id = "funding-summary",
        card(card_header("Federal Funding Summary"), card_body(uiOutput("funding_summary_box")))
      ),
      div(id = "funding-by-agency",
        card(card_header("Total Federal Funding by Agency"),
             card_body(plotlyOutput("funding_by_agency", height = "800px")))
      ),
      div(id = "funding-timeline",
        card(card_header("Federal Grant Awards Over Time"),
             card_body(plotlyOutput("funding_timeline", height = "800px")))
      ),
      div(id = "funding-wc",
        card(card_header("Award Description Themes"),
             card_body(
               tags$p(class = "text-muted small",
                      "Larger words appear more frequently. Search for these keywords in the table below."),
               plotlyOutput("funding_wordcloud", height = "450px")))
      ),
      div(id = "funding-tbl",
        card(dl_header("Award Detail", "funding_download_xlsx"),
             card_body(DTOutput("funding_table")))
      )
    )
  ),

  # =========================================================================
  # Tab 3: NIH RePORTER
  # =========================================================================
  nav_panel(
    title = "NIH Funding", icon = icon("flask"),

    conditionalPanel(
      condition = "!output.nih_ready",
      load_card("flask", "NIH RePORTER Data",
                "NIH-funded opioid research projects and award details.",
                "load_nih_btn")
    ),
    conditionalPanel(
      condition = "output.nih_ready",
      tags$div(
        class = "d-flex flex-wrap gap-2 my-3 p-2 bg-light rounded shadow-sm",
        scroll_btn("nih-summary", "Summary"),
        scroll_btn("nih-by-ic", "Funding by IC"),
        scroll_btn("nih-scatter", "Project Awards"),
        scroll_btn("nih-wc", "Word Cloud"),
        scroll_btn("nih-tbl", "Data Table")
      ),
      div(id = "nih-summary",
        card(card_header("NIH RePORTER Summary"), card_body(uiOutput("nih_summary_box")))
      ),
      div(id = "nih-by-ic",
        card(card_header("NIH Funding by Institute/Center"),
             card_body(plotlyOutput("nih_by_ic", height = "800px")))
      ),
      div(id = "nih-scatter",
        card(card_header("NIH Project Awards Over Time"),
             card_body(plotlyOutput("nih_scatter", height = "800px")))
      ),
      div(id = "nih-wc",
        card(card_header("Research Themes in Project Abstracts"),
             card_body(
               tags$p(class = "text-muted small",
                      "Search for these keywords in the table below to explore specific grants."),
               plotlyOutput("nih_wordcloud", height = "450px")))
      ),
      div(id = "nih-tbl",
        card(dl_header("Project Detail", "nih_download_xlsx"),
             card_body(DTOutput("nih_table")))
      )
    )
  ),

  # =========================================================================
  # Tab 4: ClinicalTrials.gov
  # =========================================================================
  nav_panel(
    title = "Clinical Trials", icon = icon("stethoscope"),

    conditionalPanel(
      condition = "!output.ct_ready",
      load_card("stethoscope", "ClinicalTrials.gov Data",
                "Opioid-related clinical trials: fentanyl, naloxone, buprenorphine interventions.",
                "load_ct_btn")
    ),
    conditionalPanel(
      condition = "output.ct_ready",
      tags$div(
        class = "d-flex flex-wrap gap-2 my-3 p-2 bg-light rounded shadow-sm",
        scroll_btn("ct-summary", "Summary"),
        scroll_btn("ct-timeline", "Timeline"),
        scroll_btn("ct-wc", "Word Cloud"),
        scroll_btn("ct-tbl", "Data Table")
      ),
      div(id = "ct-summary",
        card(card_header("ClinicalTrials.gov Summary"), card_body(uiOutput("ct_summary_box")))
      ),
      div(id = "ct-timeline",
        card(card_header("Clinical Trials by Start Year and Status"),
             card_body(plotlyOutput("ct_timeline", height = "700px")))
      ),
      div(id = "ct-wc",
        card(card_header("Intervention and Population Themes"),
             card_body(
               tags$p(class = "text-muted small",
                      "Search for these keywords in the table below to explore specific trials."),
               plotlyOutput("ct_wordcloud", height = "450px")))
      ),
      div(id = "ct-tbl",
        card(dl_header("Clinical Trial Detail", "ct_download_xlsx"),
             card_body(DTOutput("ct_table")))
      )
    )
  ),

  # =========================================================================
  # Tab 5: PubMed
  # =========================================================================
  nav_panel(
    title = "PubMed", icon = icon("book-medical"),

    conditionalPanel(
      condition = "!output.pubmed_ready",
      load_card("book-medical", "PubMed Research Literature",
                "Opioid overdose and fentanyl research articles via NCBI E-utilities.",
                "load_pubmed_btn")
    ),
    conditionalPanel(
      condition = "output.pubmed_ready",
      tags$div(
        class = "d-flex flex-wrap gap-2 my-3 p-2 bg-light rounded shadow-sm",
        scroll_btn("pm-summary", "Summary"),
        scroll_btn("pm-timeline", "Timeline"),
        scroll_btn("pm-wc", "Word Cloud"),
        scroll_btn("pm-tbl", "Data Table")
      ),
      div(id = "pm-summary",
        card(card_header("PubMed Search Summary"), card_body(uiOutput("pubmed_summary_box")))
      ),
      div(id = "pm-timeline",
        card(card_header("Publication Trends Over Time"),
             card_body(plotlyOutput("pubmed_timeline", height = "700px")))
      ),
      div(id = "pm-wc",
        card(card_header("Research Themes in Article Titles"),
             card_body(
               tags$p(class = "text-muted small",
                      "Search for these keywords in the table below to find specific articles."),
               plotlyOutput("pubmed_wordcloud", height = "450px")))
      ),
      div(id = "pm-tbl",
        card(dl_header("Publication Detail", "pubmed_download_xlsx"),
             card_body(DTOutput("pubmed_table")))
      )
    )
  ),

  # =========================================================================
  # Tab 6: Europe PMC
  # =========================================================================
  nav_panel(
    title = "Europe PMC", icon = icon("globe-europe"),

    conditionalPanel(
      condition = "!output.epmc_ready",
      load_card("globe-europe", "Europe PMC Literature",
                "Open access literature including PubMed, preprints, patents, and clinical guidelines.",
                "load_epmc_btn")
    ),
    conditionalPanel(
      condition = "output.epmc_ready",
      tags$div(
        class = "d-flex flex-wrap gap-2 my-3 p-2 bg-light rounded shadow-sm",
        scroll_btn("epmc-summary", "Summary"),
        scroll_btn("epmc-timeline", "Timeline"),
        scroll_btn("epmc-wc", "Word Cloud"),
        scroll_btn("epmc-tbl", "Data Table")
      ),
      div(id = "epmc-summary",
        card(card_header("Europe PMC Summary"), card_body(uiOutput("epmc_summary_box")))
      ),
      div(id = "epmc-timeline",
        card(card_header("Publications by Year"),
             card_body(plotlyOutput("epmc_timeline", height = "700px")))
      ),
      div(id = "epmc-wc",
        card(card_header("Research Themes"),
             card_body(
               tags$p(class = "text-muted small",
                      "Search for these keywords in the table below to find specific publications."),
               plotlyOutput("epmc_wordcloud", height = "450px")))
      ),
      div(id = "epmc-tbl",
        card(dl_header("Article Detail", "epmc_download_xlsx"),
             card_body(DTOutput("epmc_table")))
      )
    )
  ),

  # =========================================================================
  # Tab 7: About
  # =========================================================================
  nav_panel(
    title = "About", icon = icon("info-circle"),
    card(
      card_header("About This Dashboard"),
      card_body(
        tags$div(class = "text-center mb-4",
          tags$img(src = "logo.png", height = "80px", class = "mb-2"),
          tags$h4("Drug Overdose Crisis Explorer")
        ),
        tags$p(
          "This interactive dashboard accompanies ",
          tags$strong("Chapter 1: The U.S. Drug Overdose Crisis"),
          " of the ",
          tags$a("Public Health Analytics Playbook",
                 href = "https://andre-inter-collab-llc.github.io/Public_Health_Analytics_Playbook/chapters/01-drug-overdose-crisis.html",
                 target = "_blank"), "."
        ),
        tags$p(
          "It integrates data from six public sources to provide a comprehensive ",
          "view of the U.S. drug overdose crisis: mortality surveillance, federal funding ",
          "allocations, peer-reviewed research, funded research projects, open access ",
          "literature, and active clinical trials."
        ),
        tags$h5("Data Sources"),
        tags$ul(
          tags$li(tags$strong("CDC VSRR:"), " ",
                  tags$a("Provisional Drug Overdose Death Counts",
                         href = "https://data.cdc.gov/NCHS/VSRR-Provisional-Drug-Overdose-Death-Counts/xkb8-kh2a",
                         target = "_blank")),
          tags$li(tags$strong("USAspending:"), " ",
                  tags$a("Federal Award Data",
                         href = "https://api.usaspending.gov/", target = "_blank")),
          tags$li(tags$strong("PubMed:"), " ",
                  tags$a("NCBI E-utilities",
                         href = "https://www.ncbi.nlm.nih.gov/books/NBK25501/",
                         target = "_blank")),
          tags$li(tags$strong("NIH RePORTER:"), " ",
                  tags$a("Research Portfolio Online Reporting Tools",
                         href = "https://reporter.nih.gov/", target = "_blank")),
          tags$li(tags$strong("Europe PMC:"), " ",
                  tags$a("Open Access Literature",
                         href = "https://europepmc.org/", target = "_blank")),
          tags$li(tags$strong("ClinicalTrials.gov:"), " ",
                  tags$a("Clinical Research Registry",
                         href = "https://clinicaltrials.gov/", target = "_blank"))
        ),
        tags$h5("Key Details"),
        tags$ul(
          tags$li(tags$strong("Overdose counts:"),
                  " 12-month ending provisional counts (rolling totals)."),
          tags$li(tags$strong("Predicted values:"),
                  " Model-adjusted counts correcting for reporting delays."),
          tags$li(tags$strong("Drug categories:"),
                  " Based on ICD-10 multiple cause-of-death codes."),
          tags$li(tags$strong("Excel downloads:"),
                  " Every data table has a Download Excel button for offline analysis.")
        ),
        tags$hr(),
        tags$h5("Open Source"),
        tags$p(
          "All source code for this dashboard and the accompanying chapter is publicly available on ",
          tags$a("GitHub",
                 href = "https://github.com/andre-inter-collab-llc/Public-Health-Analytics-Playbook",
                 target = "_blank"), "."
        ),
        tags$hr(),
        tags$p(
          class = "text-muted small",
          "Built with R Shiny by Andr\u00e9 van Zyl, ",
          tags$a("Intersect Collaborations LLC",
                 href = "https://intersectcollaborations.com", target = "_blank"),
          ". Published under MIT License."
        )
      )
    )
  ),

  # Footer
  nav_spacer(),
  nav_item(
    tags$a(icon("github"), " GitHub",
           href = "https://github.com/andre-inter-collab-llc/Public-Health-Analytics-Playbook",
           target = "_blank", class = "nav-link")
  )
)
