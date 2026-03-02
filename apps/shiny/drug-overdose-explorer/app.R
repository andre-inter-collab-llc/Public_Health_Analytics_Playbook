# =============================================================================
# Drug Overdose Crisis Explorer
# Interactive R Shiny Dashboard
#
# Data Source: CDC VSRR Provisional Drug Overdose Death Counts
#   Dataset ID: xkb8-kh2a
#   API: https://data.cdc.gov/resource/xkb8-kh2a.json
#   Documentation: https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm
#
# Part of: Public Health Analytics Playbook
#   https://andre-inter-collab-llc.github.io/Public-Health-Analytics-Playbook/
#
# Author: André van Zyl, Intersect Collaborations LLC
# =============================================================================

library(shiny)
library(bslib)
library(httr2)
library(jsonlite)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(DT)
library(scales)

# =============================================================================
# Brand Colors (from _brand.yml)
# =============================================================================
brand <- list(
  blue  = "#2494f7",
  teal  = "#00a4bb",
  navy  = "#01272f",
  dark  = "#020506",
  slate = "#204d70",
  ivory = "#fffff0",
  white = "#ffffff"
)

# Drug category color palette for consistent plotting
# Indicator names match exactly what the CDC Socrata API returns
drug_colors <- c(
  "Number of Drug Overdose Deaths"                                             = brand$navy,
  "Number of Deaths"                                                           = "#7f8c8d",
  "Heroin (T40.1)"                                                             = "#e74c3c",
  "Natural & semi-synthetic opioids (T40.2)"                                   = "#e67e22",
  "Methadone (T40.3)"                                                          = "#f39c12",
  "Synthetic opioids, excl. methadone (T40.4)"                                 = "#8e44ad",
  "Cocaine (T40.5)"                                                            = "#2ecc71",
  "Psychostimulants with abuse potential (T43.6)"                               = "#3498db",
  "Natural, semi-synthetic, & synthetic opioids, incl. methadone (T40.2-T40.4)" = "#1abc9c",
  "Natural & semi-synthetic opioids, incl. methadone (T40.2, T40.3)"           = "#d35400",
  "Opioids (T40.0-T40.4,T40.6)"                                               = "#c0392b",
  "Percent with drugs specified"                                               = "#95a5a6"
)

# Month lookup for proper date parsing
month_lookup <- c(
  "January" = 1, "February" = 2, "March" = 3, "April" = 4,
  "May" = 5, "June" = 6, "July" = 7, "August" = 8,
  "September" = 9, "October" = 10, "November" = 11, "December" = 12
)

# US state FIPS and abbreviation lookup for the choropleth map
state_info <- data.frame(
  state_name = c(
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
    "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia",
    "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
    "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
    "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
    "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
    "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
  ),
  state_code = c(
    "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA",
    "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA",
    "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY",
    "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX",
    "UT", "VT", "VA", "WA", "WV", "WI", "WY"
  ),
  stringsAsFactors = FALSE
)

# =============================================================================
# Data Loading Function
# =============================================================================
load_cdc_data <- function() {
  cdc_url <- "https://data.cdc.gov/resource/xkb8-kh2a.json"

  # Pull all data (paginate since Socrata caps at 50,000 per request)
  all_data <- list()
  offset <- 0
  page_size <- 50000

  repeat {
    response <- tryCatch({
      request(cdc_url) |>
        req_url_query(
          `$limit`  = page_size,
          `$offset` = offset,
          `$order`  = "year ASC, month ASC"
        ) |>
        req_perform()
    }, error = function(e) NULL)

    if (is.null(response)) break

    page <- resp_body_json(response, simplifyVector = TRUE)
    if (nrow(page) == 0) break

    all_data <- c(all_data, list(page))
    offset <- offset + page_size

    if (nrow(page) < page_size) break
  }

  raw <- bind_rows(all_data)

  # Parse and clean
  raw |>
    mutate(
      data_value      = as.numeric(data_value),
      predicted_value = as.numeric(predicted_value),
      year_num        = as.integer(year),
      month_num       = month_lookup[month],
      date            = as.Date(paste(year_num, month_num, "01", sep = "-")),
      percent_complete = as.numeric(gsub("%", "", percent_complete))
    ) |>
    filter(!is.na(date))
}


# =============================================================================
# UI
# =============================================================================
ui <- page_navbar(
  title = tags$span(
    tags$strong("Drug Overdose Crisis Explorer"),
    style = "font-family: 'Inter', sans-serif;"
  ),
  id = "main_nav",
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = brand$blue,
    secondary = brand$teal,
    bg = brand$white,
    fg = brand$dark,
    base_font = font_google("Inter"),
    heading_font = font_google("Inter"),
    code_font = font_google("Fira Code"),
    "navbar-bg" = brand$navy
  ),
  navbar_options = navbar_options(bg = brand$navy, theme = "dark"),

  # --- Tab 1: National Overview -----------------------------------------
  nav_panel(
    title = "National Overview",
    icon = icon("chart-line"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Filters",
        width = 300,
        selectInput(
          "national_indicator", "Drug Category",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        sliderInput(
          "national_years", "Year Range",
          min = 2015, max = 2026,
          value = c(2015, 2026),
          step = 1,
          sep = "",
          ticks = FALSE
        ),
        radioButtons(
          "national_value_type", "Death Count Type",
          choices = c("Reported" = "data_value", "Predicted (adjusted)" = "predicted_value"),
          selected = "data_value"
        ),
        hr(),
        tags$p(
          class = "text-muted small",
          "Data: CDC VSRR Provisional Drug Overdose Death Counts.",
          tags$br(),
          "12-month ending provisional counts."
        )
      ),
      card(
        card_header("U.S. Drug Overdose Deaths Over Time"),
        plotlyOutput("national_trend_plot", height = "500px")
      ),
      layout_columns(
        col_widths = c(6, 6),
        card(
          card_header("Latest 12-Month Totals by Drug Category"),
          plotlyOutput("national_bar_chart", height = "400px")
        ),
        card(
          card_header("Summary Statistics"),
          DTOutput("national_summary_table")
        )
      )
    )
  ),

  # --- Tab 2: State Explorer --------------------------------------------
  nav_panel(
    title = "State Explorer",
    icon = icon("map"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Filters",
        width = 300,
        selectInput(
          "state_select", "Select State(s)",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        selectInput(
          "state_indicator", "Drug Category",
          choices = NULL,
          selected = NULL
        ),
        sliderInput(
          "state_years", "Year Range",
          min = 2015, max = 2026,
          value = c(2015, 2026),
          step = 1,
          sep = "",
          ticks = FALSE
        ),
        radioButtons(
          "state_value_type", "Death Count Type",
          choices = c("Reported" = "data_value", "Predicted (adjusted)" = "predicted_value"),
          selected = "data_value"
        ),
        hr(),
        actionButton("state_add_four_corners", "Add Four Corners States",
                      class = "btn-outline-primary btn-sm w-100 mb-2"),
        actionButton("state_add_top10", "Add Top 10 States (by deaths)",
                      class = "btn-outline-primary btn-sm w-100"),
        hr(),
        tags$p(
          class = "text-muted small",
          "Select states to compare overdose trends side by side."
        )
      ),
      card(
        card_header("State Choropleth Map (Latest Period)"),
        plotlyOutput("state_map", height = "450px")
      ),
      card(
        card_header("State Trends Over Time"),
        plotlyOutput("state_trend_plot", height = "500px")
      ),
      card(
        card_header("State Data Table"),
        DTOutput("state_data_table")
      )
    )
  ),

  # --- Tab 3: Drug Categories -------------------------------------------
  nav_panel(
    title = "Drug Categories",
    icon = icon("pills"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Filters",
        width = 300,
        selectInput(
          "drug_state", "Jurisdiction",
          choices = NULL,
          selected = NULL
        ),
        checkboxGroupInput(
          "drug_categories", "Drug Categories",
          choices = NULL,
          selected = NULL
        ),
        sliderInput(
          "drug_years", "Year Range",
          min = 2015, max = 2026,
          value = c(2015, 2026),
          step = 1,
          sep = "",
          ticks = FALSE
        ),
        hr(),
        tags$p(
          class = "text-muted small",
          "A single death may involve multiple substances and appear in more than one category."
        )
      ),
      card(
        card_header("Drug Category Trends"),
        plotlyOutput("drug_trend_plot", height = "500px")
      ),
      layout_columns(
        col_widths = c(6, 6),
        card(
          card_header("Latest Period: Deaths by Drug Category"),
          plotlyOutput("drug_bar_chart", height = "400px")
        ),
        card(
          card_header("Proportional Change Over Time"),
          plotlyOutput("drug_area_chart", height = "400px")
        )
      )
    )
  ),

  # --- Tab 4: State Comparisons ------------------------------------------
  nav_panel(
    title = "State Comparisons",
    icon = icon("balance-scale"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Compare",
        width = 300,
        selectInput(
          "compare_state_a", "State A",
          choices = NULL, selected = NULL
        ),
        selectInput(
          "compare_state_b", "State B",
          choices = NULL, selected = NULL
        ),
        selectInput(
          "compare_indicator", "Drug Category",
          choices = NULL, selected = NULL
        ),
        hr(),
        tags$p(
          class = "text-muted small",
          "Compare overdose trends head to head between two states."
        )
      ),
      card(
        card_header("Head-to-Head Comparison"),
        plotlyOutput("compare_plot", height = "500px")
      ),
      card(
        card_header("Comparison Data"),
        DTOutput("compare_table")
      )
    )
  ),

  # --- Tab 5: About -----------------------------------------------------
  nav_panel(
    title = "About",
    icon = icon("info-circle"),
    layout_columns(
      col_widths = c(8, 4),
      card(
        card_header("About This Dashboard"),
        card_body(
          tags$h4("Drug Overdose Crisis Explorer"),
          tags$p(
            "This interactive dashboard accompanies ",
            tags$strong("Chapter 1: The U.S. Drug Overdose Crisis"),
            " of the ",
            tags$a("Public Health Analytics Playbook",
                   href = "https://andre-inter-collab-llc.github.io/Public-Health-Analytics-Playbook/",
                   target = "_blank"),
            "."
          ),
          tags$h5("Data Source"),
          tags$p(
            tags$a("VSRR Provisional Drug Overdose Death Counts",
                   href = "https://data.cdc.gov/NCHS/VSRR-Provisional-Drug-Overdose-Death-Counts/xkb8-kh2a",
                   target = "_blank"),
            " (Dataset ID: xkb8-kh2a)"
          ),
          tags$p(
            "Published by the ",
            tags$a("National Center for Health Statistics (NCHS)",
                   href = "https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm",
                   target = "_blank"),
            " as part of the Vital Statistics Rapid Release (VSRR) program."
          ),
          tags$h5("Key Details"),
          tags$ul(
            tags$li(tags$strong("Counts:"), " 12-month ending provisional counts (rolling totals)."),
            tags$li(tags$strong("Predicted Values:"), " Model-adjusted counts correcting for reporting delays."),
            tags$li(tags$strong("Drug Categories:"), " Based on ICD-10 multiple cause-of-death codes. A single death may involve multiple substances."),
            tags$li(tags$strong("Suppression:"), " Counts below 10 are suppressed by CDC to prevent identification.")
          ),
          tags$h5("ICD-10 Codes"),
          tags$ul(
            tags$li("X40-X44: Unintentional drug poisoning"),
            tags$li("X60-X64: Intentional self-poisoning (suicide)"),
            tags$li("X85: Assault by drug poisoning (homicide)"),
            tags$li("Y10-Y14: Drug poisoning of undetermined intent")
          ),
          tags$h5("Drug-Specific Codes"),
          tags$ul(
            tags$li("T40.1: Heroin"),
            tags$li("T40.2: Natural & semi-synthetic opioids (morphine, oxycodone, hydrocodone)"),
            tags$li("T40.3: Methadone"),
            tags$li("T40.4: Synthetic opioids excl. methadone (fentanyl, tramadol)"),
            tags$li("T40.5: Cocaine"),
            tags$li("T43.6: Psychostimulants with abuse potential (methamphetamine)")
          ),
          tags$hr(),
          tags$p(
            class = "text-muted small",
            "Built with R Shiny by André van Zyl, ",
            tags$a("Intersect Collaborations LLC",
                   href = "https://intersectcollaborations.com",
                   target = "_blank"),
            ". Published under MIT License."
          )
        )
      ),
      card(
        card_header("Quick Links"),
        card_body(
          tags$ul(
            tags$li(tags$a("CDC VSRR Drug Overdose Data",
                           href = "https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm",
                           target = "_blank")),
            tags$li(tags$a("CDC WONDER",
                           href = "https://wonder.cdc.gov/",
                           target = "_blank")),
            tags$li(tags$a("Dataset on data.cdc.gov",
                           href = "https://data.cdc.gov/NCHS/VSRR-Provisional-Drug-Overdose-Death-Counts/xkb8-kh2a",
                           target = "_blank")),
            tags$li(tags$a("Public Health Analytics Playbook",
                           href = "https://andre-inter-collab-llc.github.io/Public-Health-Analytics-Playbook/",
                           target = "_blank")),
            tags$li(tags$a("GitHub Repository",
                           href = "https://github.com/andre-inter-collab-llc/Public-Health-Analytics-Playbook",
                           target = "_blank"))
          )
        )
      )
    )
  ),

  # Footer
  nav_spacer(),
  nav_item(
    tags$a(
      icon("github"), " GitHub",
      href = "https://github.com/andre-inter-collab-llc/Public-Health-Analytics-Playbook",
      target = "_blank",
      class = "nav-link"
    )
  )
)


# =============================================================================
# Server
# =============================================================================
server <- function(input, output, session) {

  # --- Reactive: Load data once on app start ---
  cdc_data <- reactiveVal(NULL)
  loading_complete <- reactiveVal(FALSE)

  observe({
    showNotification("Loading data from CDC...", id = "loading", duration = NULL, type = "message")
    tryCatch({
      data <- load_cdc_data()
      cdc_data(data)
      loading_complete(TRUE)
      removeNotification("loading")
      showNotification(
        paste("Loaded", format(nrow(data), big.mark = ","), "records from CDC."),
        type = "message", duration = 5
      )
    }, error = function(e) {
      removeNotification("loading")
      showNotification(
        paste("Error loading data:", e$message),
        type = "error", duration = 10
      )
    })
  })

  # --- Populate UI controls once data is loaded ---
  observe({
    req(loading_complete())
    data <- cdc_data()

    indicators <- sort(unique(data$indicator))
    states <- sort(unique(data$state_name[data$state_name != "United States"]))
    year_range <- range(data$year_num, na.rm = TRUE)

    # Drug indicators (excluding the total for drug category specific views)
    drug_specific <- indicators[indicators != "Number of Drug Overdose Deaths"]

    # --- National Overview ---
    updateSelectInput(session, "national_indicator",
                      choices = indicators,
                      selected = "Number of Drug Overdose Deaths")
    updateSliderInput(session, "national_years",
                      min = year_range[1], max = year_range[2],
                      value = year_range)

    # --- State Explorer ---
    updateSelectInput(session, "state_select",
                      choices = states,
                      selected = c("Colorado", "New Mexico"))
    updateSelectInput(session, "state_indicator",
                      choices = indicators,
                      selected = "Number of Drug Overdose Deaths")
    updateSliderInput(session, "state_years",
                      min = year_range[1], max = year_range[2],
                      value = year_range)

    # --- Drug Categories ---
    updateSelectInput(session, "drug_state",
                      choices = c("United States", states),
                      selected = "United States")
    updateCheckboxGroupInput(session, "drug_categories",
                              choices = drug_specific,
                              selected = c(
                                "Heroin (T40.1)",
                                "Synthetic opioids, excl. methadone (T40.4)",
                                "Cocaine (T40.5)",
                                "Psychostimulants with abuse potential (T43.6)"
                              ))
    updateSliderInput(session, "drug_years",
                      min = year_range[1], max = year_range[2],
                      value = year_range)

    # --- State Comparisons ---
    updateSelectInput(session, "compare_state_a",
                      choices = c("United States", states),
                      selected = "Colorado")
    updateSelectInput(session, "compare_state_b",
                      choices = c("United States", states),
                      selected = "New Mexico")
    updateSelectInput(session, "compare_indicator",
                      choices = indicators,
                      selected = "Number of Drug Overdose Deaths")
  })

  # --- Quick-add buttons ---
  observeEvent(input$state_add_four_corners, {
    updateSelectInput(session, "state_select",
                      selected = c("Arizona", "Colorado", "New Mexico", "Utah"))
  })

  observeEvent(input$state_add_top10, {
    req(loading_complete())
    data <- cdc_data()
    top10 <- data |>
      filter(
        state_name != "United States",
        indicator == "Number of Drug Overdose Deaths",
        !is.na(data_value)
      ) |>
      group_by(state_name) |>
      filter(date == max(date)) |>
      ungroup() |>
      arrange(desc(data_value)) |>
      slice_head(n = 10) |>
      pull(state_name)
    updateSelectInput(session, "state_select", selected = top10)
  })

  # =========================================================================
  # Tab 1: National Overview
  # =========================================================================

  national_filtered <- reactive({
    req(loading_complete(), input$national_indicator)
    data <- cdc_data()
    data |>
      filter(
        state_name == "United States",
        indicator %in% input$national_indicator,
        year_num >= input$national_years[1],
        year_num <= input$national_years[2]
      )
  })

  output$national_trend_plot <- renderPlotly({
    df <- national_filtered()
    req(nrow(df) > 0)

    val_col <- input$national_value_type
    val_label <- ifelse(val_col == "data_value", "Reported Deaths", "Predicted Deaths")

    p <- ggplot(df, aes(x = date, y = .data[[val_col]],
                        color = indicator, group = indicator,
                        text = paste0(
                          "<b>", indicator, "</b><br>",
                          "Period ending: ", format(date, "%B %Y"), "<br>",
                          val_label, ": ", format(.data[[val_col]], big.mark = ",")
                        ))) +
      geom_line(linewidth = 1.1) +
      scale_y_continuous(labels = comma_format()) +
      scale_color_manual(values = drug_colors, na.value = brand$slate) +
      labs(
        x = "12-Month Period Ending",
        y = val_label,
        color = "Category"
      ) +
      theme_minimal(base_family = "Inter") +
      theme(
        legend.position = "bottom",
        legend.title = element_text(face = "bold"),
        plot.title = element_text(face = "bold")
      )

    ggplotly(p, tooltip = "text") |>
      layout(
        legend = list(orientation = "h", y = -0.2),
        xaxis = list(rangeslider = list(visible = TRUE))
      )
  })

  output$national_bar_chart <- renderPlotly({
    req(loading_complete())
    data <- cdc_data()

    latest <- data |>
      filter(
        state_name == "United States",
        indicator != "Number of Drug Overdose Deaths",
        !is.na(data_value)
      ) |>
      group_by(indicator) |>
      filter(date == max(date)) |>
      ungroup() |>
      arrange(desc(data_value))

    req(nrow(latest) > 0)

    p <- ggplot(latest, aes(
      x = reorder(indicator, data_value),
      y = data_value,
      fill = indicator,
      text = paste0(
        "<b>", indicator, "</b><br>",
        "Deaths: ", format(data_value, big.mark = ","), "<br>",
        "Period ending: ", format(date, "%B %Y")
      )
    )) +
      geom_col(show.legend = FALSE) +
      scale_fill_manual(values = drug_colors, na.value = brand$slate) +
      scale_y_continuous(labels = comma_format()) +
      coord_flip() +
      labs(x = NULL, y = "Deaths (12-month ending)") +
      theme_minimal(base_family = "Inter")

    ggplotly(p, tooltip = "text")
  })

  output$national_summary_table <- renderDT({
    req(loading_complete())
    data <- cdc_data()

    summary_df <- data |>
      filter(
        state_name == "United States",
        !is.na(data_value)
      ) |>
      group_by(indicator) |>
      filter(date == max(date)) |>
      ungroup() |>
      select(
        Category = indicator,
        `Period Ending` = date,
        `Reported Deaths` = data_value,
        `Predicted Deaths` = predicted_value,
        `% Complete` = percent_complete
      ) |>
      arrange(desc(`Reported Deaths`))

    datatable(
      summary_df,
      options = list(
        pageLength = 15,
        dom = "t",
        scrollX = TRUE,
        columnDefs = list(
          list(className = "dt-right", targets = c(2, 3, 4))
        )
      ),
      rownames = FALSE
    ) |>
      formatRound(c("Reported Deaths", "Predicted Deaths"), digits = 0, mark = ",") |>
      formatRound("% Complete", digits = 1)
  })

  # =========================================================================
  # Tab 2: State Explorer
  # =========================================================================

  # --- Choropleth Map ---
  output$state_map <- renderPlotly({
    req(loading_complete())
    data <- cdc_data()

    indicator_sel <- input$state_indicator
    if (is.null(indicator_sel)) indicator_sel <- "Number of Drug Overdose Deaths"

    map_data <- data |>
      filter(
        state_name != "United States",
        indicator == indicator_sel,
        !is.na(data_value)
      ) |>
      group_by(state_name) |>
      filter(date == max(date)) |>
      ungroup() |>
      left_join(state_info, by = "state_name")

    req(nrow(map_data) > 0)

    plot_geo(map_data, locationmode = "USA-states") |>
      add_trace(
        z = ~data_value,
        locations = ~state_code,
        text = ~paste0(
          "<b>", state_name, "</b><br>",
          "Deaths: ", format(data_value, big.mark = ","), "<br>",
          "Period ending: ", format(date, "%B %Y")
        ),
        hoverinfo = "text",
        color = ~data_value,
        colors = c(brand$ivory, brand$teal, brand$navy)
      ) |>
      layout(
        geo = list(
          scope = "usa",
          projection = list(type = "albers usa"),
          showlakes = TRUE,
          lakecolor = toRGB("white")
        ),
        title = list(
          text = paste("Latest", indicator_sel, "by State"),
          font = list(size = 14)
        )
      ) |>
      colorbar(title = "Deaths")
  })

  # --- State Trends ---
  output$state_trend_plot <- renderPlotly({
    req(loading_complete(), input$state_select)
    data <- cdc_data()

    indicator_sel <- input$state_indicator
    if (is.null(indicator_sel)) indicator_sel <- "Number of Drug Overdose Deaths"
    val_col <- input$state_value_type
    val_label <- ifelse(val_col == "data_value", "Reported Deaths", "Predicted Deaths")

    df <- data |>
      filter(
        state_name %in% input$state_select,
        indicator == indicator_sel,
        year_num >= input$state_years[1],
        year_num <= input$state_years[2],
        !is.na(.data[[val_col]])
      )

    req(nrow(df) > 0)

    p <- ggplot(df, aes(
      x = date, y = .data[[val_col]],
      color = state_name, group = state_name,
      text = paste0(
        "<b>", state_name, "</b><br>",
        "Period ending: ", format(date, "%B %Y"), "<br>",
        val_label, ": ", format(.data[[val_col]], big.mark = ",")
      )
    )) +
      geom_line(linewidth = 1) +
      scale_y_continuous(labels = comma_format()) +
      labs(
        x = "12-Month Period Ending",
        y = val_label,
        color = "State"
      ) +
      theme_minimal(base_family = "Inter") +
      theme(legend.position = "bottom")

    ggplotly(p, tooltip = "text") |>
      layout(
        legend = list(orientation = "h", y = -0.2),
        xaxis = list(rangeslider = list(visible = TRUE))
      )
  })

  # --- State Data Table ---
  output$state_data_table <- renderDT({
    req(loading_complete(), input$state_select)
    data <- cdc_data()

    indicator_sel <- input$state_indicator
    if (is.null(indicator_sel)) indicator_sel <- "Number of Drug Overdose Deaths"

    df <- data |>
      filter(
        state_name %in% input$state_select,
        indicator == indicator_sel,
        year_num >= input$state_years[1],
        year_num <= input$state_years[2],
        !is.na(data_value)
      ) |>
      select(
        State = state_name,
        Date = date,
        `Reported Deaths` = data_value,
        `Predicted Deaths` = predicted_value,
        `% Complete` = percent_complete
      ) |>
      arrange(State, desc(Date))

    datatable(
      df,
      options = list(
        pageLength = 20,
        scrollX = TRUE
      ),
      rownames = FALSE,
      filter = "top"
    ) |>
      formatRound(c("Reported Deaths", "Predicted Deaths"), digits = 0, mark = ",") |>
      formatRound("% Complete", digits = 1)
  })

  # =========================================================================
  # Tab 3: Drug Categories
  # =========================================================================

  drug_filtered <- reactive({
    req(loading_complete(), input$drug_categories, input$drug_state)
    data <- cdc_data()
    data |>
      filter(
        state_name == input$drug_state,
        indicator %in% input$drug_categories,
        year_num >= input$drug_years[1],
        year_num <= input$drug_years[2],
        !is.na(data_value)
      )
  })

  output$drug_trend_plot <- renderPlotly({
    df <- drug_filtered()
    req(nrow(df) > 0)

    p <- ggplot(df, aes(
      x = date, y = data_value,
      color = indicator, group = indicator,
      text = paste0(
        "<b>", indicator, "</b><br>",
        "Period ending: ", format(date, "%B %Y"), "<br>",
        "Deaths: ", format(data_value, big.mark = ",")
      )
    )) +
      geom_line(linewidth = 1) +
      scale_y_continuous(labels = comma_format()) +
      scale_color_manual(values = drug_colors, na.value = brand$slate) +
      labs(
        title = paste("Drug Category Trends:", input$drug_state),
        x = "12-Month Period Ending",
        y = "Deaths (12-month ending)",
        color = "Substance"
      ) +
      theme_minimal(base_family = "Inter") +
      theme(legend.position = "bottom")

    ggplotly(p, tooltip = "text") |>
      layout(
        legend = list(orientation = "h", y = -0.25),
        xaxis = list(rangeslider = list(visible = TRUE))
      )
  })

  output$drug_bar_chart <- renderPlotly({
    req(loading_complete(), input$drug_categories, input$drug_state)
    data <- cdc_data()

    latest <- data |>
      filter(
        state_name == input$drug_state,
        indicator %in% input$drug_categories,
        !is.na(data_value)
      ) |>
      group_by(indicator) |>
      filter(date == max(date)) |>
      ungroup() |>
      arrange(desc(data_value))

    req(nrow(latest) > 0)

    p <- ggplot(latest, aes(
      x = reorder(indicator, data_value),
      y = data_value,
      fill = indicator,
      text = paste0(
        "<b>", indicator, "</b><br>",
        "Deaths: ", format(data_value, big.mark = ","), "<br>",
        "Period: ", format(date, "%B %Y")
      )
    )) +
      geom_col(show.legend = FALSE) +
      scale_fill_manual(values = drug_colors, na.value = brand$slate) +
      scale_y_continuous(labels = comma_format()) +
      coord_flip() +
      labs(x = NULL, y = "Deaths (12-month ending)") +
      theme_minimal(base_family = "Inter")

    ggplotly(p, tooltip = "text")
  })

  output$drug_area_chart <- renderPlotly({
    df <- drug_filtered()
    req(nrow(df) > 0)

    p <- ggplot(df, aes(
      x = date, y = data_value,
      fill = indicator, group = indicator,
      text = paste0(
        "<b>", indicator, "</b><br>",
        "Period ending: ", format(date, "%B %Y"), "<br>",
        "Deaths: ", format(data_value, big.mark = ",")
      )
    )) +
      geom_area(alpha = 0.7, position = "stack") +
      scale_y_continuous(labels = comma_format()) +
      scale_fill_manual(values = drug_colors, na.value = brand$slate) +
      labs(
        x = "12-Month Period Ending",
        y = "Deaths (stacked)",
        fill = "Substance"
      ) +
      theme_minimal(base_family = "Inter") +
      theme(legend.position = "bottom")

    ggplotly(p, tooltip = "text") |>
      layout(legend = list(orientation = "h", y = -0.25))
  })

  # =========================================================================
  # Tab 4: State Comparisons
  # =========================================================================

  output$compare_plot <- renderPlotly({
    req(loading_complete(), input$compare_state_a, input$compare_state_b, input$compare_indicator)
    data <- cdc_data()

    states_sel <- c(input$compare_state_a, input$compare_state_b)
    indicator_sel <- input$compare_indicator

    df <- data |>
      filter(
        state_name %in% states_sel,
        indicator == indicator_sel,
        !is.na(data_value)
      )

    req(nrow(df) > 0)

    p <- ggplot(df, aes(
      x = date, y = data_value,
      color = state_name, group = state_name,
      text = paste0(
        "<b>", state_name, "</b><br>",
        "Period ending: ", format(date, "%B %Y"), "<br>",
        "Deaths: ", format(data_value, big.mark = ",")
      )
    )) +
      geom_line(linewidth = 1.2) +
      scale_y_continuous(labels = comma_format()) +
      scale_color_manual(
        values = setNames(c(brand$blue, brand$teal), states_sel)
      ) +
      labs(
        title = paste(indicator_sel, ":", states_sel[1], "vs.", states_sel[2]),
        x = "12-Month Period Ending",
        y = "Deaths (12-month ending)",
        color = "State"
      ) +
      theme_minimal(base_family = "Inter") +
      theme(legend.position = "bottom")

    ggplotly(p, tooltip = "text") |>
      layout(
        legend = list(orientation = "h", y = -0.15),
        xaxis = list(rangeslider = list(visible = TRUE))
      )
  })

  output$compare_table <- renderDT({
    req(loading_complete(), input$compare_state_a, input$compare_state_b, input$compare_indicator)
    data <- cdc_data()

    states_sel <- c(input$compare_state_a, input$compare_state_b)

    df <- data |>
      filter(
        state_name %in% states_sel,
        indicator == input$compare_indicator,
        !is.na(data_value)
      ) |>
      select(
        State = state_name,
        Date = date,
        `Reported Deaths` = data_value,
        `Predicted Deaths` = predicted_value,
        `% Complete` = percent_complete
      ) |>
      arrange(State, desc(Date))

    datatable(
      df,
      options = list(pageLength = 20, scrollX = TRUE),
      rownames = FALSE,
      filter = "top"
    ) |>
      formatRound(c("Reported Deaths", "Predicted Deaths"), digits = 0, mark = ",") |>
      formatRound("% Complete", digits = 1)
  })
}


# =============================================================================
# Run App
# =============================================================================
shinyApp(ui = ui, server = server)
