# Public Health Analytics Project Research: Burden, Interventions, Funding, and Data Sources Across Global, USA, Four Corners, Navajo Nation, and South Africa

## Scope and analytic frame

This research uses the public health triad of **mortality** (deaths), **morbidity** (non-fatal disease and injury), and **disability** (health loss from living with illness or impairment), with an emphasis on **DALYs** (disability-adjusted life years) where available because DALYs combine premature mortality with years lived with disability into a single burden metric. citeturn34view0turn35search13

For comparability across jurisdictions, the most consistently available sources are:
- **Burden and outcomes:** entity["organization","World Health Organization","un health agency"] Global Health Estimates (GHE) and country “health at a glance” profiles; entity["organization","Centers for Disease Control and Prevention","us public health agency"] / entity["organization","National Center for Health Statistics","cdc stats agency"] vital statistics products (USA and states); official statistical releases for South Africa; and tribal epidemiology reports for the Navajo Nation. citeturn34view0turn2search6turn19view1turn19view0  
- **Financing and spending:** WHO GHED for national health expenditure; global health financing and aid transparency datasets (OECD CRS, IATI); and U.S. federal/state transparency portals for spending. citeturn9search2turn7search6turn12search15turn8search2turn14search1  

Two important constraints shape what can be done “comparably” in analytics:
- **Sub-state disability/DALY estimates** are not published as official vital statistics in the U.S.; for states and tribes, disability burden is often proxied using functional disability prevalence systems and health condition indicators. citeturn35search0turn35search12  
- **Tribal data sovereignty and legal/privacy protections** commonly limit access to granular Indigenous health data; public outputs are often aggregated reports rather than open microdata or APIs. citeturn4search16turn41search0turn41search1  

## Highest-burden public health issues by jurisdiction

### Global and international

WHO Global Health Estimates identify a mixed burden where noncommunicable diseases (NCDs) dominate mortality, while infectious diseases, neonatal conditions, musculoskeletal conditions, and injuries remain prominent in DALYs. In 2021, the **top global causes of death** include ischaemic heart disease, COVID-19, stroke, COPD, lower respiratory infections, lung cancers, Alzheimer’s/dementias, diabetes, kidney disease, and tuberculosis. citeturn34view0  

In 2021, the **top global causes of DALYs** include COVID-19, ischaemic heart disease, stroke, lower respiratory infections, preterm birth complications, **back and neck pain**, diabetes, COPD, diarrhoeal diseases, and road injury. citeturn34view0  

For **disability specifically**, WHO characterizes low back pain as the **leading cause of disability worldwide** (high prevalence and substantial functional impact), making it a consistent “top disability” issue even where mortality is driven by other causes. citeturn6search5  

### USA

For mortality, CDC provisional national results for 2023 identify **heart disease** and **cancer** as the two leading causes of death, followed by major contributors such as unintentional injury (which includes drug poisoning/overdose), stroke, chronic lower respiratory diseases, Alzheimer’s disease, diabetes, influenza/pneumonia, kidney disease, and other leading categories in the standard NCHS ranking approach. citeturn2search6  

WHO’s “Health at a glance” profile for the U.S. provides a complementary cause-structure view for 2021, showing a heavy NCD burden (with ischemic heart disease, Alzheimer’s/dementias, stroke, COPD, and lung cancer) alongside COVID-19, and a notable contribution from **drug use disorders** in detailed causes of death. citeturn37view0turn37view1  

For combined burden (mortality + morbidity/disability), the same WHO profile includes DALYs by broad cause group, showing the U.S. DALY profile is dominated by **noncommunicable diseases**, with smaller contributions from injuries and communicable/maternal/perinatal/nutritional conditions. citeturn37view1  

### Four Corners states: Arizona, Colorado, New Mexico, Utah

For mortality, CDC “Stats of the States” provides 2023 final rankings of leading causes of death by state and selected key measures (e.g., drug overdose death rate). citeturn46view0turn46view1turn46view2turn46view3  

Across the Four Corners states, a consistent “top tier” appears: **heart disease, cancer, and accidents (unintentional injuries)** are repeatedly among the top causes, with variation in rank and the prominence of suicide and chronic liver disease/cirrhosis.

- **Arizona:** leading causes (ranked) include heart disease, cancer, accidents, chronic lower respiratory disease, stroke, Alzheimer’s disease, diabetes, suicide, chronic liver disease/cirrhosis, and hypertension. citeturn46view0  
- **Colorado:** cancer is ranked first and heart disease second; suicide is among the leading causes; and the state’s reported 2023 **drug overdose death rate** is 30.6 per 100,000. citeturn46view1  
- **New Mexico:** heart disease leads; chronic liver disease/cirrhosis is among the top causes; and the reported 2023 **drug overdose death rate** is 48.9 per 100,000 (very high relative to many states). citeturn46view2  
- **Utah:** heart disease leads; **suicide** is ranked among the leading causes; and the reported 2023 **drug overdose death rate** is 21.4 per 100,000. citeturn46view3  

For disability/morbidity at state level (as “health needs and functional impacts”), the CDC Disability and Health Data System provides state and national indicators on adults with disabilities across multiple functional types (cognitive, hearing, mobility, vision, self-care, independent living). citeturn35search12turn35search16  

### Navajo Nation

The entity["organization","Navajo Epidemiology Center","tribal epi center us"] mortality surveillance report (2018–2024) documents an injury- and substance-use–influenced mortality profile, with chronic disease remaining central.

For **2021–2024**, the report ranks leading causes of death (counts and share of deaths) with:
1) **Unintentional injuries** (12.9%, 676 deaths)  
2) **Chronic liver disease and cirrhosis** (10.9%, 573)  
3) **COVID-19** (10.0%, 527)  
4) **Diseases of heart** (8.7%, 455)  
5) **Cancer (malignant neoplasms)** (7.4%, 390)  
6) **Diabetes** (5.3%, 279)  
7) **Alcohol abuse** (4.3%, 228)  
8) **Dementia** (2.6%, 140)  
9) **Suicide** (2.6%, 137)  
10) **Influenza and pneumonia** (2.5%, 129)  
(with additional causes such as stroke, respiratory system diseases, assault, renal failure also present in extended rankings). citeturn23view0turn23view1  

The same report highlights trend shifts: COVID-19 fell from leading cause during the earlier surveillance period to third place, while unintentional injuries returned to the leading position and chronic liver disease/cirrhosis rose in rank; alcohol abuse also increased in the leading-cause ranking compared to earlier years reported by the program. citeturn19view0  

Sex-stratified leading-cause charts underscore the prominence of injury and substance-related mortality (especially among males) and continued major contributions from chronic disease. citeturn22view0turn22view1  

### South Africa

For vital registration–based national evidence, entity["organization","Statistics South Africa","national statistical office"] reports (death notification–based) show a strong NCD profile in the **leading underlying natural causes**, alongside major infectious disease contributions.

In 2022, the **ten leading underlying natural causes of death** included:
- Diabetes mellitus (rank 1, 32,863; 6.8%)
- Hypertensive diseases (rank 2, 31,230; 6.4%)
- Cerebrovascular diseases (rank 3, 28,819; 5.9%)
- HIV disease (rank 4, 20,784; 4.3%)
- Other forms of heart disease (rank 5, 20,375; 4.2%)
- Tuberculosis (rank 5, 20,372; 4.2%)
- Influenza and pneumonia (rank 7, 19,706; 4.1%)
- Other viral diseases (rank 8, 13,139; 2.7%)
- Ischaemic heart diseases (rank 8, 13,137; 2.7%)
- Chronic lower respiratory diseases (rank 10, 11,838; 2.4%) citeturn26view1  

Sex breakdown indicates diabetes is the leading underlying cause for both males and females, with tuberculosis higher-ranked for males and hypertensive diseases particularly prominent among females. citeturn27view0  

WHO’s South Africa “Health at a glance” profile (2021) emphasizes the combined burden from communicable and noncommunicable causes and injuries. It shows, for 2021, South Africa’s deaths distributed across broad groups (communicable/maternal/perinatal/nutritional, NCDs, injuries, and other COVID-related outcomes), and detailed leading causes that include COVID-19, tuberculosis, HIV/AIDS, stroke, diabetes, lower respiratory infections, and injury/violence categories such as interpersonal violence, road injury, and self-harm. citeturn40view0turn40view1turn39view0  

## Public health interventions for prevention and response

This section summarizes **public health–level interventions** that are (a) widely used internationally and (b) concretely documented in the jurisdictions above. “Prevention” includes upstream policy and program approaches; “response” includes surveillance, case management scale-up, emergency preparedness/incident management, and harm reduction.

### NCDs: cardiovascular disease, stroke, diabetes, chronic respiratory disease, cancer

WHO’s NCD “best buys” framework emphasizes cost-effective, feasible population and health-system actions—especially reducing exposure to major NCD risk factors (tobacco, alcohol, unhealthy diet, physical inactivity) and strengthening integrated chronic care. citeturn15search0  

**Cardiovascular disease and stroke**
- **Prevention:** tobacco control measures such as the WHO MPOWER package (taxes, smoke-free laws, warning labels, advertising bans, cessation support) and broader policy approaches to reduce population exposure to tobacco smoke. citeturn15search5turn15search1  
- **Response/health-system improvement (USA):** entity["organization","Million Hearts","us cvd prevention initiative"] supports improving the “ABCS” (aspirin/anticoagulant use where appropriate, blood pressure control, cholesterol management, smoking cessation) and community strategies tied to heart health. citeturn15search2turn15search10  

**Diabetes and obesity**
- **Fiscal and regulatory prevention (South Africa):** the entity["organization","South African Revenue Service","sa tax authority"] Health Promotion Levy is a sugar-based excise approach (levy applied per gram of sugar above a specified threshold) designed to reduce sugar-sweetened beverage sugar content/consumption incentives. citeturn16search1turn16search5  
- **Fiscal prevention and community wellness funding (Navajo Nation):** the Healthy Diné Nation Act included a junk food tax; a CDC evaluation reported gross revenue and disbursements from this policy (and describes it as a sovereign tribal taxation approach supporting community wellness investments). citeturn17search8turn17search0  
- **Programmatic prevention/response in Indian Country:** entity["organization","Indian Health Service","us hhs tribal health"]–coordinated SDPI activities report improvements in diabetes-related outcomes in American Indian/Alaska Native populations, including large declines in diabetic eye disease compared with earlier decades, and broader progress in treatment and prevention infrastructure. citeturn17search3  

**Cancer**
- Public health strategies commonly combine risk-factor reduction (tobacco control), vaccination where relevant (e.g., HPV), screening, and referral system strengthening. In South Africa, national planning documents integrate cancer and NCD priorities within broader NCD prevention and control strategy frameworks. citeturn19view5turn15search1  

### Communicable diseases: HIV, TB, respiratory infections, and pandemic preparedness

**South Africa HIV/TB/STI response**
- The entity["organization","South African National AIDS Council","sa hiv tb council"] National Strategic Plan for HIV, TB and STIs (2023–2028) functions as a multi-sector roadmap for prevention and treatment scale-up, emphasizing equitable access, system resilience, and coordinated implementation. citeturn19view4  
- TB prevention and response interventions include systematic screening, early diagnosis (including drug-sensitive and drug-resistant TB), treatment initiation and retention, and preventive therapy among people living with HIV, as set out in South Africa’s TB guidance materials. citeturn16search3turn16search0  

**Navajo Nation COVID-19 response**
- The Navajo Nation published public health emergency orders and executive actions during the COVID-19 pandemic, including mask mandates and curfew-related restrictions, illustrating an assertive non-pharmaceutical intervention response capacity within a sovereign tribal government. citeturn17search1  

**Global prevention and response architecture (financing-linked)**
- Major infectious disease responses are often implemented through blended domestic budgets and external financing mechanisms, notably entity["organization","The Global Fund to Fight AIDS, Tuberculosis and Malaria","global health financing mech"] and entity["organization","President's Emergency Plan for AIDS Relief","us global hiv/aids program"]. These platforms shape prevention and treatment scale-up (testing, treatment, prevention commodities, health systems strengthening) through grants and program financing. citeturn9search3turn9search16  

### Injuries, violence, substance use, and suicide

**Opioid and drug overdose (USA; also relevant to state and tribal jurisdictions)**
- CDC identifies evidence-based strategies including expanding naloxone distribution, increasing access to medications for opioid use disorder (MOUD), and implementing evidence-based community prevention strategies. citeturn15search7turn15search3  

**Harm reduction policy and implementation examples in the Four Corners**
- Colorado documents harm reduction legislation expanding access to naloxone via standing orders and broadens distribution pathways through pharmacies and harm reduction organizations. citeturn18search1turn18search13  
- New Mexico’s Department of Health operates harm reduction programming that explicitly includes overdose death reduction, infectious disease prevention, and participant education as part of the service model. citeturn18search2  

**Suicide prevention**
- Utah’s statewide “Live On” campaign represents a population-level approach emphasizing education, resources, and culture change around suicide and mental health. citeturn18search3  

### Climate and extreme heat as an emerging high-mortality risk amplifier in the Southwest

Arizona’s health department describes increasing extreme heat as a driver of heat-related illness, emergency visits, and death, with a stated emphasis on preparedness and mitigation measures. citeturn18search12  
The state appointed a “Chief Heat Officer” role to oversee implementation of an extreme heat preparedness plan, illustrating institutionalization of heat response within public health leadership. citeturn18search0  

## Funding and financial investments for priority issues

Funding is easiest to quantify when it is tied to **specific programs, grants, or earmarked budget lines**. It is harder when funding is embedded in broad health system financing (e.g., hospital budgets) without disease-specific tagging. The sources below include both (a) **headline investment figures** and (b) **primary data portals** for traceable analysis.

### Global and international

- entity["organization","The Global Fund to Fight AIDS, Tuberculosis and Malaria","global health financing mech"] Eighth Replenishment: final outcome reported as **US$12.64 billion** (for the replenishment cycle referenced by the Global Fund Board communication). citeturn9search3  
- entity["organization","President's Emergency Plan for AIDS Relief","us global hiv/aids program"]: KFF summarizes cumulative PEPFAR funding as **over US$120 billion** to date and reports FY 2025 funding at **US$6.5 billion**. citeturn9search16  
- For tracking overall health expenditure levels (not disease-specific), WHO’s GHED provides open access country time series on health expenditure since 2000, with downloadable “all data” extracts. citeturn9search2turn9search6  
- For development assistance tracking (disease financing focus areas, sources, channels), the “Development Assistance for Health Database 1990–2023” is a consolidated dataset designed for longitudinal and cross-donor analysis. citeturn9search1  

### USA

- Federal domestic HIV budget tables consolidate program/account funding across agencies, including CDC domestic HIV prevention and HRSA Ryan White HIV/AIDS Program (with line items presented across FY years). citeturn8search4  
- CDC program budget pages provide appropriation-level detail for HIV, viral hepatitis, STIs, TB, and related portfolios (including enacted amounts and operating budgets in some years). citeturn8search8  
- Opioid response grants: HHS public communications report allocations including **$1.48B for State Opioid Response** and **~$63M for Tribal Opioid Response** in the cited award cycle. citeturn8search7  

For queryable federal spending:
- USAspending is the official U.S. open data source for federal spending, with a public API for programmatic analysis. citeturn8search2turn8search6  
- entity["organization","U.S. Department of Health and Human Services","us federal health dept"] TAGGS provides public transaction-level tracking of HHS grant obligations, with built-in export features and summary reporting. citeturn47search1turn47search4  

### Four Corners states

State-level “public health spending” is generally traceable through state financial transparency portals (often by agency and fund), rather than disease-by-disease budgets. Key portals for expenditure analytics include:
- Arizona OpenBooks (expenditures). citeturn14search1  
- Colorado’s Transparency Online Project (TOPS) and budget resources hub. citeturn14search2turn14search6  
- New Mexico Sunshine Portal (official spending/budgets). citeturn14search3  
- Transparent Utah (expenditures and revenue/expenditure tools). citeturn14search0turn14search4  

### Navajo Nation and tribal-serving funding streams

Several funding streams are explicitly relevant to the Navajo Nation’s burden profile (injury, chronic liver disease/alcohol, diabetes, and infectious disease preparedness):
- CDC reports over **$82.5M** provided to tribal communities via a cooperative agreement focused on strengthening public health systems and services in Indian Country (aggregate across recipients). citeturn10search2  
- SDPI: a U.S. Senate communication reports reauthorization and **$200M/year** funding level through the specified authorization period. citeturn11search8  
- Access to deeper clinical/administrative datasets (e.g., IHS NDW) is often governed through intranet access controls and permissions (see data access section below). citeturn41search1  

### South Africa

South Africa’s spending picture is a combination of (a) consolidated government allocations (including provincial spending) and (b) national department program budgets and conditional grants.

- Vulekamali consolidated “Health” spending overview reports total allocation for 2024–25 at **R 827.97 billion** (consolidated view). citeturn28view0  
- National department expenditure framing (2024 ENE, Vote 18 Health) reports the department’s budget over the MTEF and highlights key conditional grants and program components; it reports, for example, an estimated **R192.3 billion** departmental budget over the MTEF period (with large transfers to provinces for conditional grants) and describes major grants/programs shaping service delivery. citeturn45view0  
- The same ENE chapter discusses large HIV/AIDS-related components within grants and related program allocations (e.g., comprehensive HIV/AIDS component allocations over the medium term as described in the ENE narrative on program financing and targets). citeturn43view0turn45view0  

For external and disease-specific financing:
- The Global Fund’s country financial insights portal provides grant listings and financial detail for South Africa (useful for HIV/TB program financing attribution). citeturn9search19  
- Published analyses and budgets may quantify external HIV financing components (for example, a peer-reviewed analysis frames a scenario referencing PEPFAR funding magnitude within South Africa’s HIV budget envelope for a recent year). citeturn9search8  

## Global and international datasets and APIs

The following sources are especially useful for an analytics workflow (R/Python), because they publish routine updates in machine-readable form and/or provide APIs for automated retrieval.

**Accessibility categories used below**
- **A:** Routinely updated tabular datasets and/or APIs (good for R/Python ingestion)  
- **B:** Primarily static files (PDFs/reports) or web tables without stable API  
- **C:** Databases exist but access is restricted (institutional permissions/DUAs)

| Data source | What it covers for this project | Primary value | Access class |
|---|---|---:|:--:|
| WHO GHO OData API | Global health indicators (1000+ topics via GHO), machine-query via OData | Programmatic epidemiology pulls | A citeturn7search0turn7search4 |
| WHO Global Health Estimates theme pages | Ranked global causes of death and DALYs; GHE methods | High-level burden benchmarking | B (web) citeturn34view0turn35search13 |
| WHO data.who.int country dashboards (xmart API downloads) | Country indicators and downloadable data for causes, HALE, risk factors | Country profiles + data extracts | A citeturn31view0turn38search1 |
| WHO GHED | National health expenditure for 195 countries since 2000; downloadable “all data” | Financing baseline (domestic + external) | A citeturn9search2turn9search6 |
| World Bank Indicators API | 16k+ indicators, including many health series | Macroeconomic + health covariates | A citeturn7search1turn7search5 |
| OECD CRS via Data Explorer / SDMX API | Official development assistance flows by sector/purpose/recipient | Cross-donor health aid / projects | A citeturn7search2turn7search6 |
| IATI Datastore / API Gateway | Project-level aid transparency with export formats | Granular aid project tracking | A citeturn12search3turn12search15 |
| IHME Development Assistance for Health Database (GHDx) | Longitudinal DAH estimates 1990–2023 | Health aid totals by channel/focus | A (downloadable dataset) citeturn9search1turn7search11 |
| IHME API via GHDx | Programmatic access endpoints for selected IHME datasets | Automation for IHME-hosted datasets | A citeturn7search3 |
| entity["organization","UNAIDS","un hiv/aids program"] AIDSinfo + downloadable estimates | HIV epidemiology, programme coverage, and finance; downloadable spreadsheets | HIV-specific epi and finance | A/B (downloads; API not clearly documented) citeturn12search0turn42search2 |
| entity["organization","Gavi, the Vaccine Alliance","global vaccine partnership"] transparency via IATI | Country-level financial data published through IATI | Immunization financing | A citeturn12search2turn12search14 |

## United States and Four Corners data portals and spending trackers

| Data source | What it covers for this project | Primary value | Access class |
|---|---|---:|:--:|
| CDC Stats of the States | State-level leading causes of death and key measures (2023 final) | Quick state comparisons (Four Corners) | B (web + export via underlying sources) citeturn46view0turn46view1turn46view2turn46view3 |
| CDC WONDER (referenced by Stats of the States) | Mortality and birth data extracts used by NCHS/CDC | Mortality queries + exports | B (web query; exportable) citeturn46view0 |
| CDC Open Data portal (Socrata) | Public datasets across topics; API-enabled datasets | Broad morbidity and surveillance datasets | A citeturn8search0turn8search5 |
| CDC PLACES (Socrata-based portal) | Local health estimates; documentation explicitly notes R/Python access via Socrata API | Small-area chronic disease/risk estimates | A citeturn8search1 |
| CDC Disability and Health Data System (DHDS dataset) | State and national disability indicators; hosted on data.cdc.gov with API field definitions | Disability prevalence and correlates | A citeturn35search0turn35search12 |
| USAspending (site + API) | Federal spending data with public API | Federal outlays linked to programs/recipients | A citeturn8search2turn8search6 |
| HHS TAGGS | Transaction-level HHS grants tracking; exports available | HHS grant funding by program/recipient | A (exportable; not a public API) citeturn47search1turn47search4 |
| Arizona ADHS Public Health Data Portal | Consolidated public health data assets and dashboards | Arizona morbidity/mortality dashboards | A/B (portal-based; varies by dataset) citeturn14search9 |
| Colorado Health Information Dataset (CoHID) | Colorado public health indicator datasets/visualizations | Colorado outcomes and indicators | B (portal; export depends on view) citeturn1search6 |
| New Mexico IBIS | State indicator reporting system | NM outcomes and indicators | B citeturn1search7 |
| Utah IBIS-PH | State indicator reporting system including budget-related pages | UT outcomes; some budget tables | B citeturn14search20 |
| Arizona OpenBooks | State expenditures | Spending by entity/agency | B (web; export tools vary) citeturn14search1 |
| Colorado TOPS | Revenue/expenditure searchable database | State expenditure analytics | B citeturn14search2 |
| New Mexico Sunshine Portal | Official spending/budget transparency | Public sector spending | B citeturn14search3 |
| Transparent Utah | State governmental expenditures/revenue | Spending and fiscal accountability | B citeturn14search0turn14search4 |
| CMS limited data set files | Health spending/utilization microdata via DUA | High-resolution claims-based analytics | C citeturn41search11 |

## Navajo Nation and tribal-specific data sources and sovereignty

| Data source | What it covers for this project | Primary value | Access class |
|---|---|---:|:--:|
| Navajo Epidemiology Center mortality report series | Navajo Nation mortality surveillance; leading causes, trends | Primary sovereign-aligned burden reference | B (PDF reports) citeturn23view0turn23view1 |
| Navajo Nation COVID-19 public health order archive | Executive orders and public health emergency orders | Documented emergency response interventions | B citeturn17search1 |
| Healthy Diné Nation Act documentation and evaluations | Policy text and evaluations of junk food tax and revenue | NCD prevention policy + financing linkage | B citeturn17search0turn17search8 |
| IHS National Data Warehouse (NDW) / NPIRS access guidance | Describes NDW as IHS national repository; access requires intranet and permission | Core clinical/admin data (restricted) | C citeturn41search4turn41search1 |
| Tribal epi data access / DUA templates (IHS/TEC) | Sample DUAs and governance structures for tribal epi data use | Operationalizing legitimate access | C-oriented governance | citeturn41search0 |
| CDC cooperative agreements for Indian Country infrastructure | Funding for tribal public health capacity strengthening | Investment tracking (aggregate + award-level) | A/B (public pages; award tracking varies) citeturn10search2 |

A key practical note for analytics projects: access to **tribal-relevant clinical microdata** (EHR and claims-like sources) is often governed by **permissions and DUAs**, and may require tribal approvals and public health authority roles; IHS documentation describes intranet/permission dependencies for NDW reporting access. citeturn41search1turn41search0  

## South Africa registries, statistical databases, and health financing records

| Data source | What it covers for this project | Primary value | Access class |
|---|---|---:|:--:|
| Statistics South Africa mortality releases (P0309.3 series) | Causes of death using death notifications; leading causes tables | Core mortality burden evidence | B (PDF) citeturn26view1turn27view0 |
| Statistics South Africa interactive data (Nesstar / SuperWEB / time series downloads) | Downloadable datasets and tabulation tools across surveys; includes “Causes of Death” listed as available | Survey data + some cause-of-death access tools | A/B (downloadable; tool-based) citeturn48view2 |
| South African National Treasury / ENE (Vote Health) | Budget narrative and grant allocations; MTEF program funding | Official public financing record | B (PDF) citeturn45view0turn43view0 |
| Vulekamali budget portal | Consolidated spending views and downloadable datasets (CSV/XLSX; OpenSpending API referenced in guides) | Public expenditure analytics | A citeturn28view0turn30search9turn30search7 |
| “Health – Vulekamali” department pages | Department budgets with links to Excel tables and PDFs | Department-level spending plans | A/B citeturn28view1 |
| National Department of Health strategic plans (HIV/TB/STIs NSP; NCD NSP) | Intervention roadmaps, priority programs | Intervention mapping and program design | B (PDF) citeturn19view4turn19view5 |
| NICD dashboards directory (communicable disease dashboards) | Disease dashboards for surveillance and trends | Infectious disease monitoring | B (interactive dashboards; export varies) citeturn13search1turn13search13 |
| National Cancer Registry overview | NCR described as main source of national cancer incidence data | Cancer surveillance anchor | B/C (reports public; registry microdata often controlled) citeturn13search6 |
| NDoH data dictionary portal | Metadata repository; shows user login | Standards + metadata, but indicates restricted access | C (login) citeturn48view3 |
| DHIS policy statements (aggregated data accessibility) | Policy-level statement that aggregated DHIS data should be available within parameters | Governance context for routine data | B/C (policy; data access varies) citeturn41search5 |

In analytics practice, South Africa often requires linking: (1) **official mortality** (Stats SA) for cause-of-death outcomes, (2) **routine service delivery and surveillance** (NDoH systems, NICD dashboards, DHIS-derived aggregates) for program performance, and (3) **budget and grant flows** (National Treasury + Vulekamali) for financing attribution. citeturn26view1turn48view2turn28view0turn45view0