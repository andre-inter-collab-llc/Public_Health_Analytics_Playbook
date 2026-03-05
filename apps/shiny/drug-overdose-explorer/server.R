# =============================================================================
# Drug Overdose Crisis Explorer - server.R
# On-demand data loading, full-width visualizations, Excel downloads.
# =============================================================================

server <- function(input, output, session) {

  # ===========================================================================
  # Reactive data stores
  # ===========================================================================
  cdc_data     <- reactiveVal(NULL)
  funding_data <- reactiveVal(NULL)
  pubmed_data  <- reactiveVal(NULL)
  nih_data     <- reactiveVal(NULL)
  epmc_data    <- reactiveVal(NULL)
  ct_data      <- reactiveVal(NULL)

  cdc_loaded     <- reactiveVal(FALSE)
  funding_loaded <- reactiveVal(FALSE)
  pubmed_loaded  <- reactiveVal(FALSE)
  nih_loaded     <- reactiveVal(FALSE)
  epmc_loaded    <- reactiveVal(FALSE)
  ct_loaded      <- reactiveVal(FALSE)

  # ===========================================================================
  # Boolean flags for conditionalPanel visibility
  # ===========================================================================
  output$cdc_ready     <- reactive({ cdc_loaded() })
  output$funding_ready <- reactive({ funding_loaded() })
  output$pubmed_ready  <- reactive({ pubmed_loaded() })
  output$nih_ready     <- reactive({ nih_loaded() })
  output$epmc_ready    <- reactive({ epmc_loaded() })
  output$ct_ready      <- reactive({ ct_loaded() })

  outputOptions(output, "cdc_ready",     suspendWhenHidden = FALSE)
  outputOptions(output, "funding_ready", suspendWhenHidden = FALSE)
  outputOptions(output, "pubmed_ready",  suspendWhenHidden = FALSE)
  outputOptions(output, "nih_ready",     suspendWhenHidden = FALSE)
  outputOptions(output, "epmc_ready",    suspendWhenHidden = FALSE)
  outputOptions(output, "ct_ready",      suspendWhenHidden = FALSE)

  # ===========================================================================
  # Load-data button handlers (each fires once)
  # ===========================================================================

  # --- CDC ---
  observeEvent(input$load_cdc_btn, {
    showNotification("Loading CDC overdose data... this may take a moment.",
                     id = "cdc_msg", duration = NULL, type = "message")
    tryCatch({
      data <- load_cdc_data()
      cdc_data(data)
      cdc_loaded(TRUE)
      removeNotification("cdc_msg")

      indicators <- sort(unique(data$indicator))
      states <- sort(unique(data$state_name[data$state_name != "United States"]))
      yr <- range(data$year_num, na.rm = TRUE)

      updateSelectizeInput(session, "cdc_indicator",
                           choices = indicators,
                           selected = "Number of Drug Overdose Deaths",
                           server = TRUE)
      updateSelectizeInput(session, "cdc_states",
                           choices = c("United States", states),
                           selected = "United States",
                           server = TRUE)
      updateSliderInput(session, "cdc_years",
                        min = yr[1], max = yr[2], value = yr)

      showNotification(
        paste("Loaded", format(nrow(data), big.mark = ","), "CDC records."),
        type = "message", duration = 5)
    }, error = function(e) {
      removeNotification("cdc_msg")
      showNotification(paste("Error loading CDC data:", e$message),
                       type = "error", duration = 10)
    })
  }, once = TRUE)

  # --- USAspending ---
  observeEvent(input$load_funding_btn, {
    showNotification("Loading USAspending data...",
                     id = "fund_msg", duration = NULL, type = "message")
    tryCatch({
      funding_data(load_usaspending_data())
      funding_loaded(TRUE)
      removeNotification("fund_msg")
      showNotification("USAspending data loaded.", type = "message", duration = 4)
    }, error = function(e) {
      removeNotification("fund_msg")
      showNotification(paste("Error:", e$message), type = "error", duration = 10)
    })
  }, once = TRUE)

  # --- PubMed ---
  observeEvent(input$load_pubmed_btn, {
    showNotification("Loading PubMed data...",
                     id = "pm_msg", duration = NULL, type = "message")
    tryCatch({
      pubmed_data(load_pubmed_data())
      pubmed_loaded(TRUE)
      removeNotification("pm_msg")
      showNotification("PubMed data loaded.", type = "message", duration = 4)
    }, error = function(e) {
      removeNotification("pm_msg")
      showNotification(paste("Error:", e$message), type = "error", duration = 10)
    })
  }, once = TRUE)

  # --- NIH RePORTER ---
  observeEvent(input$load_nih_btn, {
    showNotification("Loading NIH RePORTER data...",
                     id = "nih_msg", duration = NULL, type = "message")
    tryCatch({
      nih_data(load_nih_reporter_data())
      nih_loaded(TRUE)
      removeNotification("nih_msg")
      showNotification("NIH RePORTER data loaded.", type = "message", duration = 4)
    }, error = function(e) {
      removeNotification("nih_msg")
      showNotification(paste("Error:", e$message), type = "error", duration = 10)
    })
  }, once = TRUE)

  # --- Europe PMC ---
  observeEvent(input$load_epmc_btn, {
    showNotification("Loading Europe PMC data...",
                     id = "epmc_msg", duration = NULL, type = "message")
    tryCatch({
      epmc_data(load_europe_pmc_data())
      epmc_loaded(TRUE)
      removeNotification("epmc_msg")
      showNotification("Europe PMC data loaded.", type = "message", duration = 4)
    }, error = function(e) {
      removeNotification("epmc_msg")
      showNotification(paste("Error:", e$message), type = "error", duration = 10)
    })
  }, once = TRUE)

  # --- ClinicalTrials.gov ---
  observeEvent(input$load_ct_btn, {
    showNotification("Loading ClinicalTrials.gov data...",
                     id = "ct_msg", duration = NULL, type = "message")
    tryCatch({
      ct_data(load_clinicaltrials_data())
      ct_loaded(TRUE)
      removeNotification("ct_msg")
      showNotification("ClinicalTrials.gov data loaded.", type = "message", duration = 4)
    }, error = function(e) {
      removeNotification("ct_msg")
      showNotification(paste("Error:", e$message), type = "error", duration = 10)
    })
  }, once = TRUE)

  # ===========================================================================
  # CDC: Top 10 button
  # ===========================================================================
  observeEvent(input$cdc_add_top10, {
    req(cdc_loaded())
    data <- cdc_data()
    top10 <- data |>
      filter(state_name != "United States",
             indicator == "Number of Drug Overdose Deaths",
             !is.na(data_value)) |>
      group_by(state_name) |> filter(date == max(date)) |> ungroup() |>
      arrange(desc(data_value)) |> slice_head(n = 10) |> pull(state_name)
    updateSelectizeInput(session, "cdc_states", selected = top10)
  })

  # ===========================================================================
  # TAB 1: CDC Overdose Mortality
  # ===========================================================================

  # Helper: selected indicator(s) and value column
  cdc_indicator <- reactive({ input$cdc_indicator })
  cdc_val_col   <- reactive({ input$cdc_value_type %||% "data_value" })
  cdc_val_label <- reactive({
    ifelse(cdc_val_col() == "data_value", "Reported Deaths", "Predicted Deaths")
  })

  # --- National Trend ---
  output$cdc_national_trend <- renderPlotly({
    req(cdc_loaded(), length(cdc_indicator()) > 0)
    val_col   <- cdc_val_col()
    val_label <- cdc_val_label()

    df <- cdc_data() |>
      filter(state_name == "United States",
             indicator %in% cdc_indicator(),
             year_num >= input$cdc_years[1],
             year_num <= input$cdc_years[2],
             !is.na(.data[[val_col]]))
    req(nrow(df) > 0)

    indicators <- unique(df$indicator)
    p <- plot_ly()
    for (ind in indicators) {
      ind_df <- df |> filter(indicator == ind)
      ind_color <- drug_colors[ind] %||% brand$slate
      p <- p |>
        add_trace(
          data = ind_df,
          x = ~date, y = ~.data[[val_col]],
          type = "scatter", mode = "lines",
          name = ind,
          line = list(color = ind_color, width = 2.5),
          hovertemplate = paste0(
            "<b>", ind, "</b><br>",
            "Period ending: %{x|%B %Y}<br>",
            val_label, ": %{y:,.0f}<extra></extra>"
          )
        )
    }
    p |>
      layout(
        title = list(
          text = "12-Month Ending Provisional Drug Overdose Deaths",
          font = list(size = 16)
        ),
        xaxis = list(
          title = "12-Month Period Ending",
          rangeslider = list(visible = TRUE),
          type = "date"
        ),
        yaxis = list(
          title = val_label,
          separatethousands = TRUE
        ),
        legend = list(orientation = "h", y = -0.12, font = list(size = 11)),
        hovermode = "x unified",
        margin = list(b = 80)
      ) |>
      config(displayModeBar = TRUE)
  })

  # --- State Choropleth Map ---
  output$cdc_state_map <- renderPlotly({
    req(cdc_loaded())
    ind <- if (length(cdc_indicator()) > 0) cdc_indicator()[1]
           else "Number of Drug Overdose Deaths"

    map_df <- cdc_data() |>
      filter(state_name != "United States", indicator == ind,
             !is.na(data_value)) |>
      group_by(state_name) |> filter(date == max(date)) |> ungroup() |>
      left_join(state_info, by = "state_name")
    req(nrow(map_df) > 0)

    plot_geo(map_df, locationmode = "USA-states") |>
      add_trace(
        z = ~data_value, locations = ~state_code,
        text = ~paste0("<b>", state_name, "</b><br>",
                       "Deaths: ", format(data_value, big.mark = ","), "<br>",
                       "Period: ", format(date, "%B %Y")),
        hoverinfo = "text", color = ~data_value,
        colors = c(brand$ivory, brand$teal, brand$navy)
      ) |>
      layout(
        geo = list(scope = "usa",
                   projection = list(type = "albers usa"),
                   showlakes = TRUE, lakecolor = toRGB("white")),
        title = list(text = paste("Latest", ind, "by State"),
                     font = list(size = 15)),
        margin = list(l = 0, r = 0, t = 40, b = 0)
      ) |> colorbar(title = "Deaths")
  })

  # --- State Trends ---
  output$cdc_state_trend <- renderPlotly({
    req(cdc_loaded(), length(input$cdc_states) > 0)
    ind <- if (length(cdc_indicator()) > 0) cdc_indicator()[1]
           else "Number of Drug Overdose Deaths"
    val_col   <- cdc_val_col()
    val_label <- cdc_val_label()

    df <- cdc_data() |>
      filter(state_name %in% input$cdc_states, indicator == ind,
             year_num >= input$cdc_years[1], year_num <= input$cdc_years[2],
             !is.na(.data[[val_col]]))
    req(nrow(df) > 0)

    state_names_sel <- unique(df$state_name)
    p <- plot_ly()
    for (st in state_names_sel) {
      st_df <- df |> filter(state_name == st)
      p <- p |>
        add_trace(
          data = st_df,
          x = ~date, y = ~.data[[val_col]],
          type = "scatter", mode = "lines",
          name = st,
          hovertemplate = paste0(
            "<b>", st, "</b><br>",
            "Period ending: %{x|%B %Y}<br>",
            val_label, ": %{y:,.0f}<extra></extra>"
          )
        )
    }
    p |>
      layout(
        title = list(
          text = paste("State Trends:", ind),
          font = list(size = 16)
        ),
        xaxis = list(
          title = "12-Month Period Ending",
          rangeslider = list(visible = TRUE),
          type = "date"
        ),
        yaxis = list(
          title = val_label,
          separatethousands = TRUE
        ),
        legend = list(orientation = "h", y = -0.12),
        hovermode = "x unified",
        margin = list(b = 80)
      ) |>
      config(displayModeBar = TRUE)
  })

  # --- Drug Category Bar Chart ---
  output$cdc_drug_bar <- renderPlotly({
    req(cdc_loaded())
    latest <- cdc_data() |>
      filter(state_name == "United States",
             indicator != "Number of Drug Overdose Deaths",
             !is.na(data_value)) |>
      group_by(indicator) |> filter(date == max(date)) |> ungroup() |>
      arrange(data_value)
    req(nrow(latest) > 0)

    bar_colors <- sapply(latest$indicator, function(ind) {
      drug_colors[ind] %||% brand$slate
    })
    plot_ly(
      data = latest,
      y = ~reorder(indicator, data_value),
      x = ~data_value,
      type = "bar",
      orientation = "h",
      marker = list(color = bar_colors),
      text = ~paste0(
        "<b>", indicator, "</b><br>",
        "Deaths: ", formatC(data_value, format = "f", digits = 0, big.mark = ","), "<br>",
        "Period: ", format(date, "%B %Y")
      ),
      hoverinfo = "text"
    ) |>
      layout(
        title = list(
          text = "Latest 12-Month Totals by Drug Category",
          font = list(size = 16)
        ),
        xaxis = list(title = "Deaths (12-month ending)", separatethousands = TRUE),
        yaxis = list(title = ""),
        hovermode = "closest"
      ) |>
      config(displayModeBar = TRUE)
  })

  # --- Drug Category Area Chart ---
  output$cdc_drug_area <- renderPlotly({
    req(cdc_loaded())
    drug_specific <- c("Heroin (T40.1)",
                       "Synthetic opioids, excl. methadone (T40.4)",
                       "Cocaine (T40.5)",
                       "Psychostimulants with abuse potential (T43.6)")

    df <- cdc_data() |>
      filter(state_name == "United States", indicator %in% drug_specific,
             year_num >= input$cdc_years[1], year_num <= input$cdc_years[2],
             !is.na(data_value))
    req(nrow(df) > 0)

    p <- plot_ly()
    for (drug in drug_specific) {
      drug_df <- df |> filter(indicator == drug) |> arrange(date)
      drug_color <- drug_colors[drug] %||% brand$slate
      p <- p |>
        add_trace(
          data = drug_df,
          x = ~date, y = ~data_value,
          type = "scatter", mode = "lines",
          stackgroup = "one",
          name = drug,
          fillcolor = paste0(drug_color, "B3"),
          line = list(color = drug_color, width = 1),
          hovertemplate = paste0(
            "<b>", drug, "</b><br>",
            "Period: %{x|%B %Y}<br>",
            "Deaths: %{y:,.0f}<extra></extra>"
          )
        )
    }
    p |>
      layout(
        title = list(
          text = "Drug Category Trends Over Time (Stacked)",
          font = list(size = 16)
        ),
        xaxis = list(title = "12-Month Period Ending", type = "date"),
        yaxis = list(title = "Deaths (stacked)", separatethousands = TRUE),
        legend = list(orientation = "h", y = -0.15),
        hovermode = "x unified",
        margin = list(b = 80)
      ) |>
      config(displayModeBar = TRUE)
  })

  # --- CDC Data Table ---
  cdc_table_data <- reactive({
    req(cdc_loaded())
    cdc_data() |>
      filter(year_num >= input$cdc_years[1], year_num <= input$cdc_years[2]) |>
      select(State = state_name, Year = year, Month = month,
             Indicator = indicator,
             `Reported Deaths` = data_value,
             `Predicted Deaths` = predicted_value,
             `% Complete` = percent_complete) |>
      arrange(State, desc(Year))
  })

  output$cdc_data_table <- renderDT({
    datatable(cdc_table_data(), filter = "top",
              options = list(pageLength = 20, scrollX = TRUE),
              rownames = FALSE) |>
      formatRound(c("Reported Deaths", "Predicted Deaths"), digits = 0, mark = ",") |>
      formatRound("% Complete", digits = 1)
  })

  output$cdc_download_xlsx <- downloadHandler(
    filename = function() paste0("cdc_overdose_data_", Sys.Date(), ".xlsx"),
    content = function(file) {
      wb <- create_excel_download(cdc_table_data(),
                                  "CDC Overdose Data",
                                  "CDC VSRR Provisional Drug Overdose Death Counts")
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )

  # ===========================================================================
  # TAB 2: Federal Funding (USAspending)
  # ===========================================================================

  output$funding_summary_box <- renderUI({
    req(funding_loaded())
    awards <- funding_data()
    tags$div(
      class = "d-flex flex-wrap gap-4 p-3",
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(nrow(awards), big.mark = ",")),
        tags$small(class = "text-muted", "Awards")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary",
                paste0("$", format(sum(awards$award_amount, na.rm = TRUE),
                                   big.mark = ","))),
        tags$small(class = "text-muted", "Total Value")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary",
                length(unique(awards$`Awarding Sub Agency`))),
        tags$small(class = "text-muted", "Agencies"))
    )
  })

  output$funding_timeline <- renderPlotly({
    req(funding_loaded())
    df <- funding_data() |>
      mutate(start_date = as.Date(`Start Date`),
             agency = `Awarding Sub Agency`,
             recipient = `Recipient Name`,
             hover_text = paste0("<b>", agency, "</b><br>",
                                "Recipient: ", recipient, "<br>",
                                "Award: $", formatC(award_amount, format = "f",
                                                     digits = 0, big.mark = ","))) |>
      filter(!is.na(start_date), !is.na(award_amount))

    plot_ly(data = df, x = ~start_date, y = ~award_amount,
            color = ~agency, colors = agency_colors,
            type = "scatter", mode = "markers",
            marker = list(size = 9, opacity = 0.7),
            text = ~hover_text, hoverinfo = "text") |>
      layout(
        title = list(text = paste0("Opioid-Related Federal Grant Awards (",
                                   year_start, "\u2013", year_end, ")"),
                     font = list(size = 17)),
        xaxis = list(title = "Award Start Date", type = "date"),
        yaxis = list(title = "Award Amount ($)", separatethousands = TRUE,
                     type = "log"),
        legend = list(title = list(text = "Agency"),
                      orientation = "h", y = -0.18, x = 0,
                      font = list(size = 10)),
        hovermode = "closest", margin = list(b = 140)
      ) |> config(displayModeBar = TRUE)
  })

  output$funding_wordcloud <- renderWordcloud2({
    req(funding_loaded())
    wc <- tibble(text = funding_data()$Description) |>
      filter(!is.na(text), text != "") |>
      unnest_tokens(word, text) |>
      anti_join(stop_words, by = "word") |>
      filter(!word %in% c("award", "grant", "funding", "program", "provide",
                           "project", "based", "including", "support", "services",
                           "funds", "federal", "national", "department", "health",
                           "1", "2", "3", "4", "5", "01", "02", "12",
                           as.character(year_start:year_end), "cfda", "fy"),
             nchar(word) > 2, !grepl("^[0-9]+$", word)) |>
      count(word, sort = TRUE) |>
      head(80)

    wordcloud2(wc, size = 0.6, color = rep_len(
      c(brand$blue, brand$teal, brand$slate, brand$navy), nrow(wc)),
      backgroundColor = "white", shape = "square")
  })

  funding_table_data <- reactive({
    req(funding_loaded())
    funding_data() |>
      mutate(`Start Date` = as.Date(`Start Date`),
             `Award Amount` = award_amount) |>
      select(`Award ID`, `Awarding Sub Agency`, `Recipient Name`,
             `Award Amount`, `Start Date`, Description)
  })

  output$funding_table <- renderDT({
    req(funding_loaded())
    display_df <- funding_data() |>
      mutate(
        `Start Date` = as.Date(`Start Date`),
        `Award Amount` = award_amount,
        Award = ifelse(
          !is.na(award_url),
          paste0('<a href="', award_url, '" target="_blank">', `Award ID`, '</a>'),
          `Award ID`
        )
      ) |>
      select(Award, `Awarding Sub Agency`, `Recipient Name`,
             `Award Amount`, `Start Date`, Description)

    datatable(display_df, filter = "top", escape = FALSE,
              options = list(pageLength = 20, scrollX = TRUE,
                             order = list(list(3, "desc")),
                             columnDefs = list(list(width = "300px", targets = 5))),
              rownames = FALSE) |>
      formatCurrency("Award Amount", digits = 0) |>
      formatDate("Start Date", method = "toLocaleDateString")
  })

  output$funding_download_xlsx <- downloadHandler(
    filename = function() paste0("usaspending_awards_", Sys.Date(), ".xlsx"),
    content = function(file) {
      dl_data <- funding_table_data()
      # Add Award ID column for linking
      dl_data <- dl_data |>
        mutate(`Award URL` = funding_data()$award_url[match(`Award ID`, funding_data()$`Award ID`)])
      dl_data <- dl_data |> select(-`Award URL`)
      wb <- create_excel_download(dl_data, "Federal Awards",
                                  "USAspending: Opioid-Related Federal Grant Awards",
                                  link_cols = list(
                                    "Award ID" = "https://www.usaspending.gov/search/?hash={value}"
                                  ))
      # For USAspending, use the generated_internal_id for the actual links
      # Since the table_data doesn't have the full URL, write with generated_internal_id
      award_ids <- dl_data$`Award ID`
      full_data <- funding_data()
      col_idx <- which(names(dl_data) == "Award ID")
      link_style <- createStyle(fontSize = 10, fontColour = brand$blue,
                                textDecoration = "underline",
                                border = "TopBottomLeftRight",
                                borderColour = "#cccccc")
      for (i in seq_along(award_ids)) {
        aid <- award_ids[i]
        row_match <- which(full_data$`Award ID` == aid)[1]
        if (!is.na(row_match) && !is.na(full_data$award_url[row_match])) {
          writeFormula(wb, "Federal Awards",
                       x = paste0('HYPERLINK("', full_data$award_url[row_match],
                                  '","', aid, '")'),
                       startCol = col_idx, startRow = i + 4)
        }
      }
      addStyle(wb, "Federal Awards", link_style,
               rows = 5:(nrow(dl_data) + 4), cols = col_idx,
               gridExpand = TRUE, stack = TRUE)
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )

  # ===========================================================================
  # TAB 3: PubMed
  # ===========================================================================

  output$pubmed_summary_box <- renderUI({
    req(pubmed_loaded())
    pm <- pubmed_data()
    tags$div(
      class = "d-flex flex-wrap gap-4 p-3",
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(pm$total_count, big.mark = ",")),
        tags$small(class = "text-muted", "Total Matches")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(nrow(pm$articles), big.mark = ",")),
        tags$small(class = "text-muted", "Retrieved")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", length(unique(pm$articles$journal))),
        tags$small(class = "text-muted", "Journals"))
    )
  })

  output$pubmed_timeline <- renderPlotly({
    req(pubmed_loaded())
    timeline_df <- pubmed_data()$articles |>
      mutate(
        pub_date_parsed = case_when(
          grepl("^\\d{4} \\w+ \\d+", pub_date) ~
            as.Date(pub_date, format = "%Y %b %d"),
          grepl("^\\d{4} \\w+", pub_date) ~
            as.Date(paste0(pub_date, " 01"), format = "%Y %b %d"),
          grepl("^\\d{4}$", pub_date) ~
            as.Date(paste0(pub_date, " Jan 01"), format = "%Y %b %d"),
          TRUE ~ NA_Date_
        ),
        pub_month = floor_date(pub_date_parsed, "month")
      ) |>
      filter(!is.na(pub_month)) |>
      count(pub_month, name = "n_articles") |> arrange(pub_month)

    plot_ly(data = timeline_df, x = ~pub_month, y = ~n_articles,
            type = "scatter", mode = "lines+markers",
            line = list(color = brand$blue, width = 2.5),
            marker = list(color = brand$blue, size = 6),
            hovertemplate = "<b>%{x|%B %Y}</b><br>Articles: %{y}<extra></extra>") |>
      layout(title = list(text = "Publications per Month", font = list(size = 17)),
             xaxis = list(title = "Publication Month", type = "date",
                          rangeslider = list(visible = TRUE)),
             yaxis = list(title = "Number of Articles"),
             hovermode = "x unified") |>
      config(displayModeBar = TRUE)
  })

  output$pubmed_wordcloud <- renderWordcloud2({
    req(pubmed_loaded())
    wc <- tibble(text = pubmed_data()$articles$title) |>
      filter(!is.na(text), text != "") |>
      unnest_tokens(word, text) |>
      anti_join(stop_words, by = "word") |>
      filter(!word %in% c("study", "analysis", "among", "associated",
                           "united", "states", "results", "based",
                           "findings", "using", "related", "data"),
             nchar(word) > 2, !grepl("^[0-9]+$", word)) |>
      count(word, sort = TRUE) |>
      head(80)

    wordcloud2(wc, size = 0.6, color = rep_len(
      c(brand$blue, brand$teal, brand$slate, brand$navy), nrow(wc)),
      backgroundColor = "white", shape = "square")
  })

  pubmed_table_data <- reactive({
    req(pubmed_loaded())
    pubmed_data()$articles |>
      select(PMID = pmid, Title = title, Journal = journal,
             `Publication Date` = pub_date, DOI = doi)
  })

  output$pubmed_table <- renderDT({
    req(pubmed_loaded())
    display_df <- pubmed_data()$articles |>
      mutate(
        PMID = ifelse(!is.na(pmid),
                      paste0('<a href="https://pubmed.ncbi.nlm.nih.gov/', pmid,
                             '/" target="_blank">', pmid, '</a>'), pmid),
        DOI = ifelse(!is.na(doi),
                     paste0('<a href="https://doi.org/', doi,
                            '" target="_blank">', doi, '</a>'), "")
      ) |>
      select(PMID, Title = title, Journal = journal,
             `Publication Date` = pub_date, DOI)

    datatable(display_df, filter = "top", escape = FALSE,
              options = list(pageLength = 20, scrollX = TRUE,
                             order = list(list(3, "desc")),
                             columnDefs = list(list(width = "400px", targets = 1))),
              rownames = FALSE)
  })

  output$pubmed_download_xlsx <- downloadHandler(
    filename = function() paste0("pubmed_articles_", Sys.Date(), ".xlsx"),
    content = function(file) {
      wb <- create_excel_download(
        pubmed_table_data(), "PubMed Articles",
        "PubMed: Opioid Overdose Fentanyl Research",
        link_cols = list(
          "PMID" = "https://pubmed.ncbi.nlm.nih.gov/{value}/",
          "DOI" = "https://doi.org/{value}"
        ))
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )

  # ===========================================================================
  # TAB 4: NIH RePORTER
  # ===========================================================================

  output$nih_summary_box <- renderUI({
    req(nih_loaded())
    nd <- nih_data()
    tags$div(
      class = "d-flex flex-wrap gap-4 p-3",
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(nd$total, big.mark = ",")),
        tags$small(class = "text-muted", "Total Matches")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(nrow(nd$projects), big.mark = ",")),
        tags$small(class = "text-muted", "Retrieved")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary",
                paste0("$", format(sum(nd$projects$award_amount, na.rm = TRUE),
                                   big.mark = ","))),
        tags$small(class = "text-muted", "Total Funding"))
    )
  })

  output$nih_timeline <- renderPlotly({
    req(nih_loaded())
    annual <- nih_data()$projects |>
      filter(!is.na(award_amount), !is.na(fiscal_year)) |>
      group_by(fiscal_year) |>
      summarise(total_funding = sum(award_amount, na.rm = TRUE),
                n_projects = n(), .groups = "drop") |>
      arrange(fiscal_year)

    plot_ly(data = annual, x = ~fiscal_year, y = ~total_funding,
            type = "bar", marker = list(color = brand$blue),
            text = ~paste0("<b>FY ", fiscal_year, "</b><br>",
                           "Projects: ", n_projects, "<br>",
                           "Total: $", formatC(total_funding, format = "f",
                                                digits = 0, big.mark = ",")),
            hoverinfo = "text") |>
      layout(title = list(text = "NIH Opioid Research Funding by Fiscal Year",
                          font = list(size = 17)),
             xaxis = list(title = "Fiscal Year", dtick = 1),
             yaxis = list(title = "Total Award Amount ($)",
                          separatethousands = TRUE),
             hovermode = "x unified") |>
      config(displayModeBar = TRUE)
  })

  output$nih_wordcloud <- renderWordcloud2({
    req(nih_loaded())
    wc <- tibble(text = nih_data()$projects$abstract_text) |>
      filter(!is.na(text), text != "") |>
      unnest_tokens(word, text) |>
      anti_join(stop_words, by = "word") |>
      filter(!word %in% c("study", "research", "project", "aim", "aims",
                           "specific", "propose", "proposed", "will", "use",
                           "data", "based", "including", "provide", "develop",
                           "support", "national", "health", "program", "grant",
                           "funding", "abstract", "1", "2", "3", "4", "5",
                           "r01", "r21", "r34", "k01", "k23", "u01", "p50"),
             nchar(word) > 2, !grepl("^[0-9]+$", word)) |>
      count(word, sort = TRUE) |>
      head(80)

    wordcloud2(wc, size = 0.6, color = rep_len(
      c(brand$blue, brand$teal, brand$slate, brand$navy), nrow(wc)),
      backgroundColor = "white", shape = "square")
  })

  nih_table_data <- reactive({
    req(nih_loaded())
    nih_data()$projects |>
      mutate(`Award Amount` = award_amount,
             Abstract = ifelse(!is.na(abstract_text) & nchar(abstract_text) > 200,
                               paste0(substr(abstract_text, 1, 200), "..."),
                               abstract_text)) |>
      select(`Project Number` = project_num, `Fiscal Year` = fiscal_year,
             Title = title, PI = pi_name,
             Organization = organization, `Award Amount`, Abstract)
  })

  output$nih_table <- renderDT({
    req(nih_loaded())
    display_df <- nih_data()$projects |>
      mutate(
        `Project Number` = ifelse(
          !is.na(project_num),
          paste0('<a href="https://reporter.nih.gov/project-details/',
                 gsub(" ", "", project_num),
                 '" target="_blank">', project_num, '</a>'),
          project_num),
        `Award Amount` = award_amount,
        Abstract = ifelse(!is.na(abstract_text) & nchar(abstract_text) > 200,
                          paste0(substr(abstract_text, 1, 200), "..."),
                          abstract_text)
      ) |>
      select(`Project Number`, `Fiscal Year` = fiscal_year,
             Title = title, PI = pi_name,
             Organization = organization, `Award Amount`, Abstract)

    datatable(display_df, filter = "top", escape = FALSE,
              options = list(pageLength = 20, scrollX = TRUE,
                             order = list(list(5, "desc")),
                             columnDefs = list(list(width = "300px", targets = 2),
                                               list(width = "300px", targets = 6))),
              rownames = FALSE) |>
      formatCurrency("Award Amount", digits = 0)
  })

  output$nih_download_xlsx <- downloadHandler(
    filename = function() paste0("nih_projects_", Sys.Date(), ".xlsx"),
    content = function(file) {
      wb <- create_excel_download(
        nih_table_data(), "NIH Projects",
        "NIH RePORTER: Opioid Overdose Research Projects",
        link_cols = list(
          "Project Number" = "https://reporter.nih.gov/project-details/{value}"
        ))
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )

  # ===========================================================================
  # TAB 5: Europe PMC
  # ===========================================================================

  output$epmc_summary_box <- renderUI({
    req(epmc_loaded())
    ed <- epmc_data()
    tags$div(
      class = "d-flex flex-wrap gap-4 p-3",
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(ed$hit_count, big.mark = ",")),
        tags$small(class = "text-muted", "Total Matches")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(nrow(ed$articles), big.mark = ",")),
        tags$small(class = "text-muted", "Retrieved")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary",
                sum(ed$articles$is_open_access == "Y", na.rm = TRUE)),
        tags$small(class = "text-muted", "Open Access"))
    )
  })

  output$epmc_timeline <- renderPlotly({
    req(epmc_loaded())
    by_year <- epmc_data()$articles |>
      filter(!is.na(year)) |>
      mutate(pub_year = as.integer(year)) |>
      count(pub_year, name = "n_articles") |> arrange(pub_year)

    plot_ly(data = by_year, x = ~pub_year, y = ~n_articles,
            type = "bar", marker = list(color = brand$teal),
            text = ~paste0("<b>", pub_year, "</b><br>Articles: ", n_articles),
            hoverinfo = "text") |>
      layout(title = list(text = "Europe PMC: Publications by Year",
                          font = list(size = 17)),
             xaxis = list(title = "Publication Year", dtick = 1),
             yaxis = list(title = "Number of Articles"),
             hovermode = "x unified") |>
      config(displayModeBar = TRUE)
  })

  output$epmc_wordcloud <- renderWordcloud2({
    req(epmc_loaded())
    wc <- epmc_data()$articles |>
      mutate(text = paste(title, abstract, sep = " ")) |>
      select(text) |>
      filter(!is.na(text), text != " ") |>
      unnest_tokens(word, text) |>
      anti_join(stop_words, by = "word") |>
      filter(!word %in% c("study", "results", "background", "methods",
                           "conclusions", "objective", "purpose", "findings",
                           "data", "based", "including", "conclusion",
                           "aim", "abstract", "introduction"),
             nchar(word) > 2, !grepl("^[0-9]+$", word)) |>
      count(word, sort = TRUE) |>
      head(80)

    wordcloud2(wc, size = 0.6, color = rep_len(
      c(brand$blue, brand$teal, brand$slate, brand$navy), nrow(wc)),
      backgroundColor = "white", shape = "square")
  })

  epmc_table_data <- reactive({
    req(epmc_loaded())
    epmc_data()$articles |>
      mutate(`Open Access` = ifelse(is_open_access == "Y", "Yes", "No")) |>
      select(PMID = pmid, Title = title, Journal = journal,
             Year = year, `Open Access`, `Cited By` = cited_by_count, DOI = doi)
  })

  output$epmc_table <- renderDT({
    req(epmc_loaded())
    display_df <- epmc_data()$articles |>
      mutate(
        PMID = ifelse(!is.na(pmid),
                      paste0('<a href="https://europepmc.org/article/med/', pmid,
                             '" target="_blank">', pmid, '</a>'), ""),
        DOI = ifelse(!is.na(doi),
                     paste0('<a href="https://doi.org/', doi,
                            '" target="_blank">', doi, '</a>'), ""),
        `Open Access` = ifelse(is_open_access == "Y", "Yes", "No")
      ) |>
      select(PMID, Title = title, Journal = journal,
             Year = year, `Open Access`, `Cited By` = cited_by_count, DOI)

    datatable(display_df, filter = "top", escape = FALSE,
              options = list(pageLength = 20, scrollX = TRUE,
                             order = list(list(5, "desc")),
                             columnDefs = list(list(width = "400px", targets = 1))),
              rownames = FALSE)
  })

  output$epmc_download_xlsx <- downloadHandler(
    filename = function() paste0("europe_pmc_articles_", Sys.Date(), ".xlsx"),
    content = function(file) {
      wb <- create_excel_download(
        epmc_table_data(), "Europe PMC",
        "Europe PMC: Opioid Overdose Fentanyl Research",
        link_cols = list(
          "PMID" = "https://europepmc.org/article/med/{value}",
          "DOI" = "https://doi.org/{value}"
        ))
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )

  # ===========================================================================
  # TAB 6: ClinicalTrials.gov
  # ===========================================================================

  output$ct_summary_box <- renderUI({
    req(ct_loaded())
    cd <- ct_data()
    tags$div(
      class = "d-flex flex-wrap gap-4 p-3",
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(cd$total, big.mark = ",")),
        tags$small(class = "text-muted", "Total Matches")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary", format(nrow(cd$trials), big.mark = ",")),
        tags$small(class = "text-muted", "Retrieved")),
      tags$div(class = "p-3 bg-light rounded text-center",
        tags$h3(class = "mb-0 text-primary",
                sum(cd$trials$status == "RECRUITING", na.rm = TRUE)),
        tags$small(class = "text-muted", "Currently Recruiting"))
    )
  })

  output$ct_timeline <- renderPlotly({
    req(ct_loaded())
    timeline_df <- ct_data()$trials |>
      mutate(start_year = as.integer(substr(start_date, 1, 4))) |>
      filter(!is.na(start_year)) |>
      count(start_year, status, name = "n_trials") |> arrange(start_year)

    status_colors <- c("COMPLETED" = brand$blue,
                       "ACTIVE_NOT_RECRUITING" = brand$teal,
                       "RECRUITING" = brand$slate)

    plot_ly(data = timeline_df, x = ~start_year, y = ~n_trials,
            color = ~status, colors = status_colors, type = "bar",
            text = ~paste0("<b>", start_year, "</b><br>",
                           status, ": ", n_trials, " trials"),
            hoverinfo = "text") |>
      layout(title = list(text = "Clinical Trials by Start Year and Status",
                          font = list(size = 17)),
             xaxis = list(title = "Start Year", dtick = 1),
             yaxis = list(title = "Number of Trials"),
             barmode = "stack",
             legend = list(title = list(text = "Status"),
                           orientation = "h", y = -0.15, x = 0),
             hovermode = "x unified") |>
      config(displayModeBar = TRUE)
  })

  output$ct_wordcloud <- renderWordcloud2({
    req(ct_loaded())
    wc <- ct_data()$trials |>
      mutate(text = paste(title, description, sep = " ")) |>
      select(text) |>
      filter(!is.na(text), text != " ") |>
      unnest_tokens(word, text) |>
      anti_join(stop_words, by = "word") |>
      filter(!word %in% c("study", "trial", "clinical", "phase",
                           "participants", "purpose", "determine",
                           "evaluate", "assess", "including", "based",
                           "aims", "aim", "objective", "primary"),
             nchar(word) > 2, !grepl("^[0-9]+$", word)) |>
      count(word, sort = TRUE) |>
      head(80)

    wordcloud2(wc, size = 0.6, color = rep_len(
      c(brand$blue, brand$teal, brand$slate, brand$navy), nrow(wc)),
      backgroundColor = "white", shape = "square")
  })

  ct_table_data <- reactive({
    req(ct_loaded())
    ct_data()$trials |>
      mutate(Description = ifelse(!is.na(description) & nchar(description) > 200,
                                  paste0(substr(description, 1, 200), "..."),
                                  description)) |>
      select(`NCT ID` = nct_id, Title = title, Status = status,
             `Start Date` = start_date, Sponsor = sponsor,
             Enrollment = enrollment, Description)
  })

  output$ct_table <- renderDT({
    req(ct_loaded())
    display_df <- ct_data()$trials |>
      mutate(
        `NCT ID` = ifelse(!is.na(nct_id),
                          paste0('<a href="https://clinicaltrials.gov/study/',
                                 nct_id, '" target="_blank">', nct_id, '</a>'),
                          nct_id),
        Description = ifelse(!is.na(description) & nchar(description) > 200,
                             paste0(substr(description, 1, 200), "..."),
                             description)
      ) |>
      select(`NCT ID`, Title = title, Status = status,
             `Start Date` = start_date, Sponsor = sponsor,
             Enrollment = enrollment, Description)

    datatable(display_df, filter = "top", escape = FALSE,
              options = list(pageLength = 20, scrollX = TRUE,
                             order = list(list(3, "desc")),
                             columnDefs = list(list(width = "300px", targets = 1),
                                               list(width = "300px", targets = 6))),
              rownames = FALSE)
  })

  output$ct_download_xlsx <- downloadHandler(
    filename = function() paste0("clinical_trials_", Sys.Date(), ".xlsx"),
    content = function(file) {
      wb <- create_excel_download(
        ct_table_data(), "Clinical Trials",
        "ClinicalTrials.gov: Opioid Overdose Intervention Trials",
        link_cols = list(
          "NCT ID" = "https://clinicaltrials.gov/study/{value}"
        ))
      saveWorkbook(wb, file, overwrite = TRUE)
    }
  )
}
