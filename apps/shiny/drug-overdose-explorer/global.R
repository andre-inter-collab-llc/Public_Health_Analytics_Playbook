# =============================================================================
# Drug Overdose Crisis Explorer - global.R
# Shared configuration, constants, and data loading functions
#
# Data Sources:
#   1. CDC VSRR Provisional Drug Overdose Death Counts (Socrata)
#   2. USAspending Federal Grant Awards
#   3. PubMed (NCBI E-utilities)
#   4. NIH RePORTER (Funded Research Projects)
#   5. Europe PMC (Open Access Literature)
#   6. ClinicalTrials.gov (Clinical Research)
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
library(plotly)
library(DT)
library(tidytext)
library(wordcloud2)
library(openxlsx)
library(lubridate)

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
drug_colors <- c(
  "Number of Drug Overdose Deaths"                                              = brand$navy,
  "Number of Deaths"                                                            = "#7f8c8d",
  "Heroin (T40.1)"                                                              = "#e74c3c",
  "Natural & semi-synthetic opioids (T40.2)"                                    = "#e67e22",
  "Methadone (T40.3)"                                                           = "#f39c12",
  "Synthetic opioids, excl. methadone (T40.4)"                                  = "#8e44ad",
  "Cocaine (T40.5)"                                                             = "#2ecc71",
  "Psychostimulants with abuse potential (T43.6)"                               = "#3498db",
  "Natural, semi-synthetic, & synthetic opioids, incl. methadone (T40.2-T40.4)" = "#1abc9c",
  "Natural & semi-synthetic opioids, incl. methadone (T40.2, T40.3)"           = "#d35400",
  "Opioids (T40.0-T40.4,T40.6)"                                                = "#c0392b",
  "Percent with drugs specified"                                                = "#95a5a6"
)

# Agency color palette for USAspending
agency_colors <- c(
  "#2494f7", "#00a4bb", "#01272f", "#204d70",
  "#e07b39", "#6b4c9a", "#d94f4f", "#2ca02c",
  "#8c564b", "#17becf", "#bcbd22", "#7f7f7f"
)

# Month lookup for proper date parsing
month_lookup <- c(
  "January" = 1, "February" = 2, "March" = 3, "April" = 4,
  "May" = 5, "June" = 6, "July" = 7, "August" = 8,
  "September" = 9, "October" = 10, "November" = 11, "December" = 12
)

# US state abbreviation lookup for the choropleth map
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

# Dynamic date window
date_end   <- Sys.Date()
date_start <- as.Date(paste0(as.integer(format(date_end, "%Y")) - 5, "-01-01"))
year_end   <- as.integer(format(date_end, "%Y"))
year_start <- year_end - 5

# =============================================================================
# Data Loading Functions
# =============================================================================

load_cdc_data <- function() {
  cdc_url <- "https://data.cdc.gov/resource/xkb8-kh2a.json"
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
  raw |>
    mutate(
      data_value       = as.numeric(data_value),
      predicted_value  = as.numeric(predicted_value),
      year_num         = as.integer(year),
      month_num        = month_lookup[month],
      date             = as.Date(paste(year_num, month_num, "01", sep = "-")),
      percent_complete = as.numeric(gsub("%", "", percent_complete))
    ) |>
    filter(!is.na(date)) |>
    distinct(state_name, indicator, date, .keep_all = TRUE)
}

load_usaspending_data <- function() {
  url <- "https://api.usaspending.gov/api/v2/search/spending_by_award/"
  request_body <- list(
    filters = list(
      keywords = list("opioid", "overdose", "substance abuse"),
      time_period = list(
        list(start_date = format(date_start, "%Y-%m-%d"),
             end_date   = format(date_end, "%Y-%m-%d"))
      ),
      award_type_codes = c("02", "03", "04", "05")
    ),
    fields = c(
      "Award ID", "Recipient Name", "Award Amount",
      "Awarding Agency", "Awarding Sub Agency",
      "Start Date", "End Date", "Description",
      "generated_internal_id"
    ),
    limit = 100,
    page = 1
  )

  all_results <- list()
  for (pg in 1:100) {
    request_body$page <- pg
    resp <- tryCatch({
      request(url) |> req_body_json(request_body) |> req_perform()
    }, error = function(e) NULL)
    if (is.null(resp)) break
    page_data <- resp_body_json(resp, simplifyVector = TRUE)
    if (is.null(page_data$results) || nrow(page_data$results) == 0) break
    all_results[[pg]] <- page_data$results
    if (nrow(page_data$results) < 100) break
  }

  bind_rows(all_results) |>
    as_tibble() |>
    mutate(
      award_amount = as.numeric(`Award Amount`),
      award_url = ifelse(
        !is.na(generated_internal_id) & generated_internal_id != "",
        paste0("https://www.usaspending.gov/award/", generated_internal_id),
        NA_character_
      )
    ) |>
    arrange(desc(award_amount))
}

load_pubmed_data <- function() {
  esearch_url <- "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
  search_resp <- request(esearch_url) |>
    req_url_query(
      db       = "pubmed",
      term     = "opioid overdose fentanyl United States[Title/Abstract]",
      retmax   = 10000,
      sort     = "date",
      retmode  = "json",
      mindate  = format(date_start, "%Y/%m/%d"),
      maxdate  = format(date_end, "%Y/%m/%d"),
      datetype = "pdat"
    ) |>
    req_perform()

  search_results <- resp_body_json(search_resp)
  pmids <- search_results$esearchresult$idlist
  total_count <- as.integer(search_results$esearchresult$count)

  if (length(pmids) == 0) {
    return(list(
      articles = tibble(pmid = character(), title = character(),
                        journal = character(), pub_date = character(),
                        doi = character()),
      total_count = total_count
    ))
  }

  esummary_url <- "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi"
  summary_resp <- request(esummary_url) |>
    req_url_query(db = "pubmed", id = paste(pmids, collapse = ","), retmode = "json") |>
    req_perform()
  summaries <- resp_body_json(summary_resp)

  articles <- lapply(pmids, function(id) {
    article <- summaries$result[[id]]
    tibble(
      pmid     = id,
      title    = article$title %||% NA_character_,
      journal  = article$fulljournalname %||% NA_character_,
      pub_date = article$pubdate %||% NA_character_,
      doi      = {
        doi_ids <- Filter(function(x) x$idtype == "doi", article$articleids)
        if (length(doi_ids) > 0) doi_ids[[1]]$value else NA_character_
      }
    )
  }) |> bind_rows()

  list(articles = articles, total_count = total_count)
}

load_nih_reporter_data <- function() {
  url <- "https://api.reporter.nih.gov/v2/projects/search"
  all_projects <- list()
  for (pg in 0:99) {
    body <- list(
      criteria = list(
        advanced_text_search = list(
          operator = "and",
          search_field = "projecttitle,terms",
          search_text = "opioid overdose fentanyl"
        ),
        fiscal_years = as.list((year_end - 4L):year_end),
        exclude_subprojects = TRUE
      ),
      offset = pg * 100, limit = 100,
      sort_field = "FiscalYear", sort_order = "desc"
    )
    resp <- tryCatch({
      request(url) |> req_body_json(body) |> req_perform()
    }, error = function(e) NULL)
    if (is.null(resp)) break
    data <- resp_body_json(resp)
    if (length(data$results) == 0) break
    all_projects[[pg + 1]] <- data$results
    if (length(data$results) < 100) break
  }

  total <- data$meta$total

  projects <- lapply(unlist(all_projects, recursive = FALSE), function(p) {
    tibble(
      project_num   = p$project_num %||% NA_character_,
      fiscal_year   = p$fiscal_year %||% NA_integer_,
      title         = p$project_title %||% NA_character_,
      pi_name       = {
        if (!is.null(p$principal_investigators) && length(p$principal_investigators) > 0)
          p$principal_investigators[[1]]$full_name
        else NA_character_
      },
      organization  = p$organization$org_name %||% NA_character_,
      award_amount  = p$award_amount %||% NA_real_,
      abstract_text = p$abstract_text %||% NA_character_
    )
  }) |> bind_rows()

  list(projects = projects, total = total)
}

load_europe_pmc_data <- function() {
  url <- "https://www.ebi.ac.uk/europepmc/webservices/rest/search"
  epmc_all <- list()
  epmc_cursor <- "*"
  for (pg in 1:50) {
    resp <- tryCatch({
      request(url) |>
        req_url_query(
          query      = paste0("(opioid overdose fentanyl) AND (PUB_YEAR:[",
                              year_start, " TO ", year_end, "])"),
          format     = "json",
          pageSize   = 1000,
          cursorMark = epmc_cursor,
          resultType = "core"
        ) |>
        req_perform()
    }, error = function(e) NULL)
    if (is.null(resp)) break
    data <- resp_body_json(resp)
    if (length(data$resultList$result) == 0) break
    epmc_all[[pg]] <- data$resultList$result
    epmc_cursor <- data$nextCursorMark %||% NULL
    if (is.null(epmc_cursor) || length(data$resultList$result) < 1000) break
  }

  hit_count <- data$hitCount

  articles <- lapply(unlist(epmc_all, recursive = FALSE), function(a) {
    tibble(
      pmid           = a$pmid %||% NA_character_,
      title          = a$title %||% NA_character_,
      journal        = a$journalTitle %||% NA_character_,
      year           = a$pubYear %||% NA_character_,
      first_pub_date = a$firstPublicationDate %||% NA_character_,
      is_open_access = a$isOpenAccess %||% "N",
      cited_by_count = a$citedByCount %||% 0L,
      doi            = a$doi %||% NA_character_,
      abstract       = a$abstractText %||% NA_character_
    )
  }) |> bind_rows()

  list(articles = articles, hit_count = hit_count)
}

load_clinicaltrials_data <- function() {
  url <- "https://clinicaltrials.gov/api/v2/studies"
  all_trials <- list()
  next_token <- NULL
  for (pg in 1:10) {
    ct_query <- list(
      `query.cond`  = "opioid overdose",
      `query.intr`  = "fentanyl OR naloxone OR buprenorphine",
      `filter.overallStatus` = "RECRUITING,ACTIVE_NOT_RECRUITING,COMPLETED",
      countTotal    = "true",
      pageSize      = 100,
      sort          = "LastUpdatePostDate:desc"
    )
    if (!is.null(next_token)) ct_query$pageToken <- next_token

    resp <- tryCatch({
      request(url) |> req_url_query(!!!ct_query) |> req_perform()
    }, error = function(e) NULL)
    if (is.null(resp)) break
    data <- resp_body_json(resp)
    if (length(data$studies) == 0) break
    all_trials[[pg]] <- data$studies
    next_token <- data$nextPageToken
    if (is.null(next_token)) break
  }

  total <- data$totalCount

  trials <- lapply(unlist(all_trials, recursive = FALSE), function(s) {
    proto <- s$protocolSection
    id_mod <- proto$identificationModule
    status_mod <- proto$statusModule
    sponsor_mod <- proto$sponsorCollaboratorsModule
    design_mod <- proto$designModule
    desc_mod <- proto$descriptionModule

    tibble(
      nct_id      = id_mod$nctId %||% NA_character_,
      title       = id_mod$briefTitle %||% NA_character_,
      status      = status_mod$overallStatus %||% NA_character_,
      start_date  = status_mod$startDateStruct$date %||% NA_character_,
      sponsor     = sponsor_mod$leadSponsor$name %||% NA_character_,
      enrollment  = design_mod$enrollmentInfo$count %||% NA_integer_,
      description = desc_mod$briefSummary %||% NA_character_
    )
  }) |> bind_rows()

  list(trials = trials, total = total)
}

# =============================================================================
# Helper: Create a professional Excel workbook from a dataframe
# with clickable hyperlinks for ID columns
# =============================================================================
create_excel_download <- function(df, sheet_name = "Data", title = "Export",
                                  link_cols = NULL) {
  # link_cols: named list mapping column name -> URL template with {value} placeholder
  # e.g. list("PMID" = "https://pubmed.ncbi.nlm.nih.gov/{value}/")

  wb <- createWorkbook()
  addWorksheet(wb, sheet_name)

  # Title style
  title_style <- createStyle(
    fontSize = 14, fontColour = brand$navy,
    textDecoration = "bold", border = "bottom",
    borderColour = brand$blue, borderStyle = "medium"
  )

  # Header style
  header_style <- createStyle(
    fontSize = 11, fontColour = brand$white,
    fgFill = brand$navy, textDecoration = "bold",
    halign = "center", border = "TopBottomLeftRight",
    borderColour = brand$slate
  )

  # Body style
  body_style <- createStyle(
    fontSize = 10, border = "TopBottomLeftRight",
    borderColour = "#cccccc", wrapText = TRUE
  )

  # Link style
  link_style <- createStyle(
    fontSize = 10, fontColour = brand$blue,
    textDecoration = "underline", border = "TopBottomLeftRight",
    borderColour = "#cccccc"
  )

  # Write title row
  writeData(wb, sheet_name, x = title, startCol = 1, startRow = 1)
  addStyle(wb, sheet_name, title_style, rows = 1, cols = 1)
  mergeCells(wb, sheet_name, cols = 1:ncol(df), rows = 1)

  # Source line
  writeData(wb, sheet_name,
            x = paste("Exported from Drug Overdose Crisis Explorer on", Sys.Date()),
            startCol = 1, startRow = 2)
  addStyle(wb, sheet_name,
           createStyle(fontSize = 9, fontColour = "#666666", textDecoration = "italic"),
           rows = 2, cols = 1)

  # Write data starting at row 4
  writeData(wb, sheet_name, x = df, startCol = 1, startRow = 4,
            headerStyle = header_style)
  addStyle(wb, sheet_name, body_style,
           rows = 5:(nrow(df) + 4), cols = 1:ncol(df),
           gridExpand = TRUE, stack = TRUE)

  # Add clickable hyperlinks for specified columns
  if (!is.null(link_cols) && nrow(df) > 0) {
    for (col_name in names(link_cols)) {
      col_idx <- which(names(df) == col_name)
      if (length(col_idx) == 0) next
      url_template <- link_cols[[col_name]]
      for (i in seq_len(nrow(df))) {
        cell_val <- df[[col_name]][i]
        if (!is.na(cell_val) && nchar(trimws(as.character(cell_val))) > 0) {
          url <- gsub("{value}", as.character(cell_val), url_template, fixed = TRUE)
          writeFormula(wb, sheet_name,
                       x = paste0('HYPERLINK("', url, '","', cell_val, '")'),
                       startCol = col_idx, startRow = i + 4)
        }
      }
      addStyle(wb, sheet_name, link_style,
               rows = 5:(nrow(df) + 4), cols = col_idx,
               gridExpand = TRUE, stack = TRUE)
    }
  }

  # Auto-width columns (cap at 50)
  setColWidths(wb, sheet_name, cols = 1:ncol(df), widths = "auto")

  # Freeze panes below header
  freezePane(wb, sheet_name, firstActiveRow = 5, firstActiveCol = 1)

  wb
}
