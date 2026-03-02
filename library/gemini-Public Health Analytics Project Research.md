# **Epidemiological Public Health Reporting and Analytics: A Multi-Jurisdictional Assessment of Morbidity, Mortality, Interventions, and Data Infrastructure**

The foundation of modern epidemiological public health reporting and analytics relies heavily on the continuous, systematic collection, analysis, and interpretation of health-related data. As global and regional populations undergo complex demographic and epidemiological transitions, the burden of disease is shifting profoundly. Concurrently, the financial architectures that support public health interventions are under unprecedented strain. Constructing a robust, automated analytics project requires not only an exhaustive understanding of prevailing morbidities and mortalities but also a rigorous evaluation of the data pipelines, application programming interfaces (APIs), and tabular repositories available to ingest this data into computational environments such as R or Python.

This comprehensive assessment systematically evaluates the greatest public health challenges—characterized by the leading causes of mortality, morbidity, and disability—alongside the preventative interventions, financial investments, and programmatic data access points. The analysis is stratified across five distinct administrative and geographic jurisdictions: the global level, the United States of America, the Four Corners states (Arizona, Colorado, New Mexico, and Utah), the Navajo Nation, and the Republic of South Africa.

## **1\. Global and International Level**

### **1.1 Epidemiological Profile: The Shifting Burden of Disease**

At the international level, a profound epidemiological transition is well underway. Historically dominated by communicable, maternal, neonatal, and nutritional diseases, the global burden of disease has decisively shifted toward non-communicable diseases (NCDs) in recent decades. Rapid global progress in fighting infectious diseases—driven by massive international coordination—has been counterbalanced by mounting, systemic challenges associated with chronic pathologies. Currently, half of the top ten leading causes of early death and disability worldwide are non-communicable diseases.1

Between 2013 and 2023, epidemiological surveillance recorded sharp, statistically significant increases in healthy years lost due to diabetes, as well as anxiety and depressive disorders.1 The primary risk factors driving Disability-Adjusted Life Years (DALYs) globally are high systolic blood pressure, ambient particulate air pollution, and tobacco use.2 Furthermore, a strong inverse correlation exists between a region’s Socio-Demographic Index (SDI) and DALY rates; low and low-middle SDI regions report significantly higher DALY rates, reaching up to 189,563 and 165,080 per 100,000 population, respectively.2 Conversely, global health loss from risk factors other than high body mass index (BMI) and high fasting plasma glucose is generally dropping.1

The COVID-19 pandemic introduced a massive, albeit transient, disruption to global mortality trends. The SARS-CoV-2 virus claimed approximately 18 million lives between 2019 and 2023\.1 However, as the virus entered an endemic phase, it ceased to be a major overarching driver of global mortality by the end of 2023\.1 Consequently, global life expectancy has largely rebounded to pre-pandemic baselines in two-thirds of surveyed countries and territories.1 Looking forward, sophisticated epidemiological forecasting to the year 2050 indicates that ischemic heart disease and cerebrovascular disease (stroke) will firmly entrench themselves as the dominant causes of health loss globally.3 In parallel, diabetes, drug use disorders, interpersonal violence, and climate-driven heat waves pose some of the fastest-rising threats to human health and systemic stability.1

### **1.2 Interventions, Prevention Strategies, and Financial Investments**

Global public health interventions are largely coordinated through multilateral organizations, sovereign health ministries, and massive bilateral aid programs. Significant historical investments have been channeled into combating infectious diseases through mechanisms like the Global Fund to Fight AIDS, Tuberculosis, and Malaria, which was established in 2001 to pool resources and combat epidemic-prone pathogens.4

However, the international financing landscape is highly susceptible to geopolitical shifts and domestic policy realignments in donor nations. Projections indicate that reductions in United States bilateral health aid could result in catastrophic, cascading resurgences of preventable diseases. For instance, modeled cuts to global tuberculosis (TB) funding are projected to cause an additional 2.5 million pediatric TB cases and 340,000 pediatric TB deaths in low- and middle-income countries between 2025 and 2034\.5 If financial support to the Global Fund is concurrently withdrawn, these figures are modeled to escalate drastically to 8.9 million child TB cases and 1.5 million deaths over the same decade.5

Financially, global expenditure on healthcare as a share of world income has been steadily increasing, though profound, structural inequities remain. High-income countries spend substantially more on healthcare per capita, whereas low-income countries rely heavily on out-of-pocket (OOP) expenditures.6 In many low- and middle-income nations, OOP expenditures frequently exceed 50% of total health spending, which acts as a severe barrier to preventative care and drives catastrophic health expenditures that push families into poverty.6

| Intervention Domain | Target Pathology | Funding Mechanism & Financial Implications |
| :---- | :---- | :---- |
| **Infectious Disease Control** | HIV/AIDS, TB, Malaria | The Global Fund; U.S. bilateral aid (USAID, PEPFAR). Vulnerable to policy shifts; modeled to cost 1.5M pediatric lives if funding ceases.4 |
| **NCD Management** | Heart Disease, Diabetes | Domestic health budgets. Heavy reliance on out-of-pocket spending in low-income nations (\>50% of total expenditure).6 |
| **Maternal & Child Health** | Infant Mortality, Neonatal Care | International aid and domestic scaling. Successfully drove under-five mortality below 10 million annually by 2006\.4 |

### **1.3 Data Infrastructure and Analytical Access**

For programmatic analytics utilizing R or Python, the global health data ecosystem offers some of the most mature application programming interfaces (APIs) and tabular repositories available.

**World Health Organization (WHO) Global Health Observatory (GHO):** The GHO serves as the WHO's premier gateway to health-related statistics, tracking over 1,000 indicators across 194 Member States to monitor progress toward the Sustainable Development Goals (SDGs).7 Data can be queried directly into computational environments using the GHO OData API or the Athena API.9

* **API Endpoint Architecture:** The OData protocol allows for robust REST-based queries. The base URL for dimension discovery is https://ghoapi.azureedge.net/api/Dimension.9  
* **Data Ingestion for R/Python:** Analysts can parse JSON responses directly via standard HTTP requests. For example, to retrieve specific indicator metadata regarding household pollution, a query can be routed to https://ghoapi.azureedge.net/api/Indicator?$filter=contains(IndicatorName,'Household').9 Targeted indicator data (e.g., life expectancy, coded as WHOSIS\_000001) is accessible via https://ghoapi.azureedge.net/api/WHOSIS\_000001.9 The data is highly structured, routinely updated, and supports time-dimension and demographic filtering natively in the URL string (e.g., $filter=Dim1 eq 'MLE' and date(TimeDimensionBegin) ge 2011-01-01).9

**Global Burden of Disease (GBD) Datasets:** Managed by the Institute for Health Metrics and Evaluation (IHME), the GBD study provides comprehensive estimates for over 375 diseases and injuries, and 88 risk factors across 204 countries.3

* **Tabular Access:** Analysts can utilize the GBD Results Tool (https://vizhub.healthdata.org/gbd-results/) to export extensive CSV files containing point estimates and 95% uncertainty intervals for incidence, prevalence, YLLs, YLDs, and DALYs.3 Access requires creating a free institutional or personal account.3 Due to the massive scale of the data (over 1 billion data points), programmatic downloads are best managed by identifying specific prepackaged hierarchical zip files or utilizing authenticated session tokens in Python.3

**Global Health Expenditure Database (GHED):** To track independent financial variables, the WHO GHED provides comparable, longitudinally harmonized data on health expenditure disaggregated by source (government, OOP, donors) and by disease cohort.10

* **Tabular Access:** The entire GHED dataset is available for bulk download in machine-readable XLSX and CSV formats via https://apps.who.int/nha/database/Select/Indicators/en.10 This dataset is vital for establishing econometric regression models linking public health spending variables to GBD mortality outcomes.

**Restricted Data Access Tiers:** While the aggregated estimates from WHO and IHME are public, the underlying micro-data (e.g., raw household surveys, individual civil registration vital statistics) used to generate these estimates are strictly governed. Access to these primary source datasets typically requires executing Data Use Agreements (DUAs) with the sovereign health ministries of the respective member states.3

## **2\. The United States of America**

### **2.1 Epidemiological Profile: The Dominance of Chronic Illness and Injury**

Within the United States, the epidemiological profile is overwhelmingly defined by chronic, non-communicable conditions, heavily supplemented by a deeply entrenched and anomalous crisis of unintentional injuries. The latest finalized mortality data indicates that heart disease remains the unyielding leading cause of mortality, accounting for 680,981 deaths annually, closely followed by malignant neoplasms (cancer) with 613,352 deaths.13

A critical divergence in the U.S. epidemiological landscape compared to peer high-income nations is the massive burden of unintentional injuries (222,698 deaths)—a category heavily driven by the opioid epidemic, synthetic fentanyl overdoses, and motor vehicle accidents.13 Additionally, cerebrovascular diseases or stroke (162,639 deaths), chronic lower respiratory diseases (145,357 deaths), Alzheimer's disease (114,034 deaths), and diabetes mellitus (95,190 deaths) round out the leading causes of mortality.13 In recent tracking, COVID-19 remained a notable cause of mortality, registering 49,932 deaths.13

A secondary analysis of health outcomes reveals significant systemic vulnerabilities. Premature, avoidable deaths are highly variable across the nation and are paradoxically increasing in the United States while declining in comparable high-income countries.15 The infant mortality rate—a critical proxy for overall health system efficacy—actually worsened in 20 states between 2018 and 2022\.15 Racial disparities are stark and deeply institutionalized; in 42 states and the District of Columbia, avoidable mortality for Black populations is at least double the rate of the demographic cohort with the lowest mortality.15 Furthermore, fundamental preventative indicators, such as early childhood vaccinations, have recently exhibited troubling declines exceeding 10% in several jurisdictions.15

### **2.2 Interventions, Prevention Strategies, and Financial Investments**

The U.S. healthcare system commands the highest per capita health expenditure globally, yet this spending is highly concentrated and arguably inefficient at achieving population-level health equity. It is estimated that the top 1% of spenders account for more than 20% of total healthcare expenditures, largely driven by the exorbitant costs of managing end-stage chronic diseases and intensive tertiary care.6

Federal and state public health interventions emphasize chronic disease management, substance abuse harm reduction, and maternal-infant health.13 The Affordable Care Act (ACA) drove uninsured rates to record lows by 2023, largely due to Medicaid eligibility expansions and subsidized marketplace premiums, which significantly narrowed the gap in access to preventative care between states.15 However, the fragmentation of the U.S. health system means that interventions are often managed at the state or county level, leading to heterogeneous funding allocations and highly variable intervention efficacy across state lines.15 The U.S. paradoxically spends massive amounts of government money per person on healthcare, yet achieves worse population health outcomes than many nations that fund universal, single-payer programs.6

### **2.3 Data Infrastructure and Analytical Access**

The United States provides some of the most granular, highly codified epidemiological data available globally, though access to line-level data is strictly governed by the Health Insurance Portability and Accountability Act (HIPAA) to protect patient privacy.

**CDC WONDER (Wide-ranging ONline Data for Epidemiologic Research):** CDC WONDER is the premier federal system for analyzing U.S. public health data, providing exhaustive querying capabilities for underlying and multiple causes of death based on death certificates collected by the National Vital Statistics System.16

* **Analytical Capabilities:** The system provides mortality counts, crude death rates, and age-adjusted death rates stratified by geography (national, state, county), demographics, urbanization level, and precise ICD-10 codes.16 It also features specialized databases for cancer statistics, environmental data (fine particulate matter, heat indexes), and infectious disease morbidity.18  
* **Data Ingestion for R/Python:** While the CDC is currently undergoing a digital modernization effort to improve automated data access 18, traditional programmatic interactions with WONDER are notoriously complex. The system lacks a standard modern REST API. Instead, analysts must construct XML-based POST requests to the WONDER web architecture or utilize community-built API wrappers in R (e.g., wonderapi) or Python to simulate form submissions. Results are returned as tabular text files (.txt) or CSVs, which can be loaded into pandas dataframes.18  
* **Restricted Data Access Tiers:** To prevent the identification of individuals, CDC WONDER automatically suppresses data where the number of deaths is sub-threshold (typically fewer than 10 deaths in a given stratification).18 Access to unsuppressed, line-level mortality data requires a formal Data Use Agreement (DUA) and Institutional Review Board (IRB) approval from the National Center for Health Statistics (NCHS).18 This micro-data is not publicly available for immediate programmatic querying and must be processed within secure computing enclaves.

## **3\. The Four Corners States (Arizona, Colorado, New Mexico, Utah)**

### **3.1 Epidemiological Profile: Regional Heterogeneity and Geographic Determinants**

The Four Corners region exhibits a unique blend of rapidly expanding urban growth centers, expansive rural and frontier territories, and high-altitude geography. This topological and demographic diversity results in highly variable epidemiological outcomes across the contiguous borders.

**Utah:** Utah consistently ranks as one of the healthiest states in the nation, particularly for older adults, securing the number one ranking in recent national assessments.19 This is driven by a low prevalence of excessive drinking, low poverty rates, and high levels of digital connectivity facilitating telehealth.19 However, the state faces a severe, anomalous challenge regarding suicide, which is a leading cause of premature mortality. The suicide rate for adults aged 65 and older is 21.8 per 100,000, with men experiencing rates nearly five times higher than women.19 Unintentional injuries also account for massive health loss, generating over 1,520 deaths annually.21

**Colorado:** Similar to Utah, Colorado generally ranks highly in overall physical health parameters, boasting low rates of obesity and physical inactivity.19 However, the state is grappling with an acute, systemic substance use crisis. An epidemiological analysis of mortality among people experiencing homelessness in Denver revealed that drug overdoses account for a staggering 77.09% of deaths in this vulnerable cohort.22 When examining pediatric populations, the leading causes of child and adolescent mortality highlight severe structural vulnerabilities: suicide, motor vehicle crashes, firearms, and unintentional poisoning/overdoses are the dominant killers of youth in Colorado.23

**New Mexico & Arizona:** These states face significantly elevated challenges regarding social determinants of health, deep intergenerational poverty, and chronic disease burdens. Both states struggle with high rates of heart disease and cancer.24 New Mexico specifically faces a profound crisis with alcohol-related mortality, chronic liver disease, and high rates of disabling injuries.25 Disparities are vast; poverty in the region is highly concentrated among Native American and Hispanic populations, driving unequal health outcomes across the lifespan.19

### **3.2 Interventions, Prevention Strategies, and Financial Investments**

State-level investments and intervention philosophies vary dramatically within this geographic cluster.

* **New Mexico** invests the highest amount of public health dollars per capita in the region. Recent analyses indicate New Mexico allocates $265 per person toward public health initiatives—more than double the national average of $116.26 Interventions focus heavily on expanding Medicaid eligibility, maintaining rural healthcare access clinics, and combatting the opioid and alcohol epidemics through widespread harm reduction and naloxone distribution.15  
* **Arizona** manages a massive operational budget to support its vast population. The Arizona Department of Health Services (ADHS) reported expected revenues and expenditures scaling to over $12.9 billion across federal grants, state funds, and regulatory licenses.27 Interventions here focus on adult protective services, refugee resettlement, and aging/disability services to prevent institutionalization.28  
* **Utah** leverages the Utah Healthy Places Index (HPI), a sophisticated mapping tool that directs intervention funding by analyzing 22 social determinants of health (e.g., tree canopy, transit access, poverty) to pinpoint exactly which neighborhoods require preventative investments.29

### **3.3 Data Infrastructure and Analytical Access**

The Four Corners states utilize robust open-data portals, many of which are powered by the Socrata platform, offering excellent machine-readable API access for data scientists.

| Jurisdiction | Primary Data Portal & API Architecture | Analytical Capabilities & Data Extraction |
| :---- | :---- | :---- |
| **Colorado** | CDPHE Open Data Portal (Socrata) | Data on health facilities, regional jurisdictions, and environmental tracking can be accessed via OData V2 and V4 endpoints (e.g., https://data.colorado.gov/api/views/2c44-7syn.json).30 This allows direct, refreshable connections via Python's requests library or R's httr package. The state also maintains the State Unintentional Drug Overdose Reporting System (SUDORS) for deep toxicological data.32 |
| **Utah** | State of Utah Open Data Catalog (Socrata) | Located at https://opendata.utah.gov/, this catalog provides tabular data on Medicaid prescriptions, hospital capacity, and disease incidence. The state's open data policy legally mandates machine readability, ensuring pristine CSV/JSON outputs.33 |
| **New Mexico** | NM-IBIS (Indicator-Based Information System) | An exceptionally detailed querying system (https://ibis.doh.nm.gov/) that provides record-level datasets for birth/death certificates, hospital inpatient discharges (HIDD), emergency department data, and infectious disease morbidity.35 While NM-IBIS provides exhaustive CSV exports based on user-defined query parameters, direct RESTful API endpoints are less prominent than in Socrata-based states.35 |
| **Arizona** | AZ Financial Transparency Portal / ADHS Open Data | Budget and expenditure data down to the individual payment, entity, and program level can be exported as bulk CSV files via the OpenBooks portal (https://openbooks.az.gov/expenditures).36 Public health datasets are hosted on the ADHS Data Portal.39 |

**Restricted Data Access Tiers:** While the aforementioned portals provide aggregated data, access to sensitive record-level datasets (such as individual hospital discharge records in NM-IBIS or unsuppressed vital statistics in Colorado) is restricted. In New Mexico, for example, users must be "authorized partner dataset users" (typically academic researchers or internal DOH epidemiologists) to access granular data that skirts HIPAA identification thresholds.41 Public users are restricted to aggregated summary queries.

## **4\. The Navajo Nation**

### **4.1 Epidemiological Profile: Structural Vulnerabilities and Legacy Disparities**

The Navajo Nation, spanning over 25,000 contiguous square miles across the borders of Arizona, New Mexico, and Utah, experiences a deeply inequitable epidemiological reality. The population suffers from a life expectancy that is 5.5 years lower than the United States all-races population (73.0 years compared to 78.5 years).42 The leading causes of mortality are heavily skewed by structural inequalities, economic adversity, inadequate education, and historical trauma.42

The top causes of death on the Navajo Nation include unintentional injuries, diseases of the heart, malignant neoplasms (cancer), diabetes, and chronic liver disease and cirrhosis.24 The mortality rates for chronic liver disease, diabetes mellitus, and intentional self-harm (suicide) are significantly higher than the national average.42

The COVID-19 pandemic laid bare these structural vulnerabilities, serving as a brutal stress test for the Nation's health infrastructure. During the height of the pandemic, the Navajo Nation experienced exceptionally high attack and case fatality rates.43 Deep analytical investigations revealed that while clinical comorbidities played a role, environmental factors such as the time required to travel to a grocery store (a proxy for rural isolation and food deserts) heavily influenced positive test rates.43 Interestingly, studies demonstrated that living in multigenerational homes did not independently explain the disproportionate morbidity, pointing instead to systemic under-resourcing and lack of baseline infrastructure like running water and reliable internet for telehealth.43

### **4.2 Interventions, Prevention Strategies, and Financial Investments**

Healthcare on the Navajo Nation is primarily administered by the Indian Health Service (IHS)—an agency within the U.S. Department of Health and Human Services—and authorized Tribal health corporations operating under Public Law 93-638 (Indian Self-Determination and Education Assistance Act) contracts.44

Interventions focus heavily on maintaining rural health facilities, expanding sanitation and water infrastructure, and combating metabolic disease. A flagship intervention is the Special Diabetes Program for Indians (SDPI), which provides targeted grant funding for diabetes treatment and prevention.45 Programs must select "Best Practices" and track outcomes using the SDPI Outcomes System (SOS) to ensure funds reduce the incidence of diabetic complications.45

Financially, the system operates under a chronic, historic deficit relative to actual need. For Fiscal Year 2025, the President’s Budget requested $8.2 billion for the IHS overall, representing a 16% increase from FY 2023\.46 However, the National Tribal Budget Formulation Workgroup estimated that fully addressing unfulfilled Trust and Treaty obligations, ending health disparities, and resolving life safety issues at facilities would require a comprehensively funded budget of $51.42 billion.47 The requested expansions included $12.39 billion for hospitals and clinics, $8.30 billion for purchased/referred care, and $3.57 billion for dental services.47 This massive gap highlights the severe undercapitalization of preventative and therapeutic interventions. A critical legislative intervention currently underway is the shift toward mandatory, advance appropriations to protect the IHS from federal government shutdowns and to automatically address inflationary pressures.44

### **4.3 Data Infrastructure and Analytical Access**

Accessing programmatic data for the Navajo Nation requires navigating the complex, highly sensitive intersections of public health surveillance and Indigenous data sovereignty.

**Navajo Epidemiology Center (NEC):** The NEC manages the Nation’s public health information systems and disease surveillance protocols.48 Because Tribal Epidemiology Centers (TECs) were permanently authorized as public health authorities under HIPAA via the Affordable Care Act, they have legal access to protected health information held by the U.S. Department of Health and Human Services.49

* **Public Data Access:** The NEC website (https://nec.navajo-nsn.gov/) hosts several interactive Tableau data dashboards, including visual representations for Cancer incidence (2014-2018), RSV, Flu, and the IHS Epi Data Mart.50 Publicly available reports, such as the Navajo Nation Mortality Report and Hospitalization & Emergency Room Rates, provide aggregated tabular data embedded within PDF formats.51  
* **Restricted Analytical Data:** Native American populations are frequently misclassified, underrepresented, or statistically silenced by small sample sizes in standard state and federal databases.49 Consequently, the most accurate line-level or highly stratified data resides exclusively with the NEC. This data is strictly not available via public open APIs to prevent extractive research practices.  
* **Acquiring Access:** To utilize this data in an external R/Python analytics project, researchers must execute formal Data Sharing Agreements (DSAs) and obtain rigorous approval from the Navajo Nation Human Research Review Board.49 This ensures that data is analyzed in culturally responsive ways that directly benefit the Dine people. Without these agreements, analysts must rely solely on scraping the aggregated summary data provided in the public NEC PDF reports.

## **5\. South Africa**

### **5.1 Epidemiological Profile: The Colliding Epidemics of Communicable and Chronic Diseases**

South Africa presents a highly complex, volatile epidemiological landscape characterized by a colliding quadruple burden of disease: maternal and child mortality, communicable diseases (specifically HIV and TB), non-communicable diseases (NCDs), and severe injuries/trauma resulting from interpersonal violence and road traffic accidents.

According to Statistics South Africa (Stats SA), the leading causes of death have been heavily dominated by the COVID-19 pandemic in recent years, which temporarily eclipsed endemic pathogens.52 However, the underlying, persistent drivers of mortality and morbidity remain Tuberculosis (TB) and HIV/AIDS.52 As the aggressive national rollout of antiretroviral therapy (ART) has successfully prolonged the lives of millions living with HIV, the population is undergoing an accelerated demographic transition. The population is aging, leading to a rapid acceleration in non-communicable diseases. Diabetes mellitus and cerebrovascular diseases (stroke) are now consistently ranked among the top five causes of death nationwide.52 Furthermore, interpersonal violence and lower respiratory infections generate massive morbidity and mortality, severely impacting the DALYs of the younger, economically active demographic cohorts.52

A notable success in South Africa's public health trajectory is the precipitous drop in child mortality. Driven by improved access to HIV prevention (Prevention of Mother-to-Child Transmission) and better living conditions, the infant mortality rate plummeted from 61.9 deaths per 1,000 live births in 2002 to 23.1 in 2025\.53 Similarly, the under-five mortality rate fell from 79.9 to 26.1 deaths per 1,000 live births over the same period. Consequently, life expectancy at birth has risen significantly to an estimated 64.0 years for males and 69.6 years for females in 2025\.53

### **5.2 Interventions, Prevention Strategies, and Financial Investments**

South Africa's public health interventions are primarily funded and executed by the National Department of Health, supplemented by massive international assistance programs such as the U.S. President's Emergency Plan for AIDS Relief (PEPFAR).54 Interventions focus heavily on the maintenance of the world's largest ART program, TB directly observed treatment short-course (DOTS), and increasingly, the clinical management of chronic conditions like hypertension and diabetes.54

The cost of managing this dual burden is placing immense pressure on the national fiscus. Systematic reviews indicate that hypertension drug costs range from $2 to $85 per person-month, while type 2 diabetes medications cost between $57 and $630 per person-year.55 When preventative management fails and complications arise, costs escalate dramatically—for example, haemodialysis for end-stage renal disease secondary to diabetes can exceed $25,193 per person-year.55 Furthermore, hospitalization remains the primary cost driver for cardiovascular disease, with treatment costs ranging up to $37,491 per person-year.55

Macro-level financial data reveals a stark reality regarding health investments. In the 2023/24 fiscal year, general government expenditure on health was R276 billion, representing 12% of total government expenditure.56 However, this allocation is severely constrained by macroeconomic pressures; the government's debt-servicing costs (R356 billion) consume 15% of the total budget, substantially exceeding the entire national health budget.56 This fiscal crowding-out effect severely limits the state's ability to scale up necessary interventions to meet the rising tide of NCDs and maintain vital infectious disease control programs.

### **5.3 Data Infrastructure and Analytical Access**

South Africa possesses a relatively sophisticated statistical and financial data infrastructure, allowing analysts to track both mortality events and fiscal allocations, though automated ingestion presents unique challenges.

**Epidemiological Data (Stats SA):**

* **Analytical Access:** Mortality and causes of death are tracked via the civil registration system maintained by the Department of Home Affairs and processed by Statistics South Africa, acting under the mandate of the Statistics Act.57  
* **Format Constraints & Ingestion:** The primary dissemination method for this data is through exhaustive annual PDF reports (e.g., *Mortality and causes of death in South Africa*).57 While Stats SA produces high-quality demographic data, much of the public-facing epidemiological data is trapped in static PDF tables. Analysts utilizing R or Python will need to rely on PDF parsing libraries (such as tabula-py, pdfplumber, or pdftools) to extract this data into usable CSV dataframes.59  
* **Restricted Tabular Data:** Anonymized, line-level mortality datasets (unit records) are made available to researchers upon formal request or registration through the Stats SA data portal, though they are not exposed via a live REST API.59 Usage of this raw data requires strict acknowledgment of Stats SA and cannot be resold.59

**Financial and Budgetary Data (National Treasury & Vulekamali):**

* **Analytical Access:** To correlate health outcomes with financial inputs, analysts can access the Vulekamali open budget portal (https://vulekamali.gov.za/2025-26/national/departments/health/), a joint transparency initiative by the National Treasury.60  
* **Tabular Availability:** The portal provides Estimates of National Expenditure (ENE) and adjusted budgets in highly structured, machine-readable Excel and CSV formats.60 This allows for seamless programmatic ingestion of historical expenditure time-series data, categorized down to the sub-programme level (e.g., specific budget allocations for "Communicable and Non-communicable Diseases", "Primary Health Care", and "National Health Insurance").60

## **6\. Synthesis and Data Pipeline Recommendations for the Analytics Project**

The execution of a multi-jurisdictional epidemiological reporting and analytics project requires a highly adaptable, multi-modal data engineering approach. The profound variance in data maturity, API availability, and data sovereignty laws across the investigated regions dictates that an automated Python or R pipeline cannot rely on a single ingestion methodology.

| Jurisdiction | Primary Pipeline Methodology | Tooling & Libraries Required | Access Limitations |
| :---- | :---- | :---- | :---- |
| **Global / WHO** | RESTful API (OData/Athena) | Python requests, R httr, JSON parsing | Fully public; rate limits apply. Micro-data requires DUA. |
| **USA (Federal)** | Ad-Hoc Web Query / Scraping | Python BeautifulSoup/Selenium, R wonderapi | Sub-10 counts suppressed. Line-level data requires IRB/DUA. |
| **Four Corners** | OData API (Socrata) & CSV Bulk | Python sodapy, pandas | Public aggregated. Line-level requires partner authorization. |
| **Navajo Nation** | PDF Scraping / Backend SQL | Python tabula-py | Strict tribal sovereignty. Raw data requires formal DSA/IRB. |
| **South Africa** | PDF Scraping & Excel Parsing | Python pdfplumber, openpyxl | Public PDFs. Unit records require formal Stats SA registration. |

To operationalize this project, the analytics architecture should first establish automated ingestion scripts targeting the WHO OData API and the Socrata endpoints of Colorado and Utah, as these represent the path of least resistance for establishing base epidemiological and financial tables. Simultaneously, robust PDF extraction algorithms must be developed to liberate vital statistics data from South Africa and the Navajo Nation. Finally, researchers must initiate the compliance and legal processes immediately to secure Data Use Agreements for the restricted, line-level datasets managed by the CDC, NM-IBIS, and the Navajo Epidemiology Center, as these high-fidelity data sources are paramount for training accurate predictive models regarding public health interventions and mortality outcomes.

#### **Works cited**

1. Global Burden of Disease (GBD) \- Institute for Health Metrics and Evaluation, accessed February 27, 2026, [https://www.healthdata.org/research-analysis/gbd-key-findings](https://www.healthdata.org/research-analysis/gbd-key-findings)  
2. Global burden of disease and its risk factors for adults aged 70 and older across 204 countries and territories \- PMC, accessed February 27, 2026, [https://pmc.ncbi.nlm.nih.gov/articles/PMC12220231/](https://pmc.ncbi.nlm.nih.gov/articles/PMC12220231/)  
3. Global Burden of Disease (GBD), accessed February 27, 2026, [https://www.healthdata.org/research-analysis/gbd-data](https://www.healthdata.org/research-analysis/gbd-data)  
4. Health \- the United Nations, accessed February 27, 2026, [https://www.un.org/en/global-issues/health](https://www.un.org/en/global-issues/health)  
5. U.S. funding cuts could result in nearly 9 million child tuberculosis cases, 1.5 million child deaths, accessed February 27, 2026, [https://hsph.harvard.edu/news/u-s-funding-cuts-could-result-in-nearly-9-million-child-tuberculosis-cases-1-5-million-child-deaths/](https://hsph.harvard.edu/news/u-s-funding-cuts-could-result-in-nearly-9-million-child-tuberculosis-cases-1-5-million-child-deaths/)  
6. Healthcare Spending \- Our World in Data, accessed February 27, 2026, [https://ourworldindata.org/financing-healthcare](https://ourworldindata.org/financing-healthcare)  
7. WHO's Global Health Observatory (GHO) Data | Economics \- Western Michigan University, accessed February 27, 2026, [https://wmich.edu/economics/global-health-observatory](https://wmich.edu/economics/global-health-observatory)  
8. Global Health Observatory Indicators \- World Bank Open Data, accessed February 27, 2026, [https://data360.worldbank.org/en/dataset/WHO\_GHO](https://data360.worldbank.org/en/dataset/WHO_GHO)  
9. GHO OData API \- World Health Organization (WHO), accessed February 27, 2026, [https://www.who.int/data/gho/info/gho-odata-api](https://www.who.int/data/gho/info/gho-odata-api)  
10. Global Health Expenditure Database \- World Health Organization ..., accessed February 27, 2026, [https://apps.who.int/nha/database](https://apps.who.int/nha/database)  
11. Global Health Expenditure Database \- GHELI Repository, accessed February 27, 2026, [https://repository.gheli.harvard.edu/repository/12025/](https://repository.gheli.harvard.edu/repository/12025/)  
12. Global Health Expenditure Database, accessed February 27, 2026, [https://apps.who.int/nha/database/select/indicators/en](https://apps.who.int/nha/database/select/indicators/en)  
13. Leading Causes of Death \- FastStats \- CDC, accessed February 27, 2026, [https://www.cdc.gov/nchs/fastats/leading-causes-of-death.htm](https://www.cdc.gov/nchs/fastats/leading-causes-of-death.htm)  
14. Deaths and Mortality \- FastStats \- CDC, accessed February 27, 2026, [https://www.cdc.gov/nchs/fastats/deaths.htm](https://www.cdc.gov/nchs/fastats/deaths.htm)  
15. 2025 Scorecard on State Health System Performance \- Commonwealth Fund, accessed February 27, 2026, [https://www.commonwealthfund.org/publications/scorecard/2025/jun/2025-scorecard-state-health-system-performance](https://www.commonwealthfund.org/publications/scorecard/2025/jun/2025-scorecard-state-health-system-performance)  
16. Deaths \- CDC WONDER, accessed February 27, 2026, [https://wonder.cdc.gov/deaths-by-underlying-cause.html](https://wonder.cdc.gov/deaths-by-underlying-cause.html)  
17. Multiple Cause of Death Data on CDC WONDER, accessed February 27, 2026, [https://wonder.cdc.gov/mcd.html](https://wonder.cdc.gov/mcd.html)  
18. CDC WONDER, accessed February 27, 2026, [https://wonder.cdc.gov/](https://wonder.cdc.gov/)  
19. State Rankings | 2024 Senior Report | AHR \- America's Health Rankings, accessed February 27, 2026, [https://www.americashealthrankings.org/publications/reports/2024-senior-report/state-rankings](https://www.americashealthrankings.org/publications/reports/2024-senior-report/state-rankings)  
20. State Summaries Utah | 2025 Senior Report | AHR \- America's Health Rankings, accessed February 27, 2026, [https://www.americashealthrankings.org/publications/reports/2025-senior-report/state-summaries-utah](https://www.americashealthrankings.org/publications/reports/2025-senior-report/state-summaries-utah)  
21. Health Indicator Report \- Unintentional injury deaths \- IBIS-PH \- \- Utah.gov, accessed February 27, 2026, [https://ibis.utah.gov/ibisph-view/indicator/view/UniInjDth.SA.html](https://ibis.utah.gov/ibisph-view/indicator/view/UniInjDth.SA.html)  
22. 2025 Death Review\_Final \- Colorado Coalition for the Homeless, accessed February 27, 2026, [https://www.coloradocoalition.org/sites/default/files/2025-12/2025%20Death%20Review\_Final.pdf](https://www.coloradocoalition.org/sites/default/files/2025-12/2025%20Death%20Review_Final.pdf)  
23. Child Fatality Prevention System: 2025 Annual Legislative Report, accessed February 27, 2026, [https://ncfrp.org/wp-content/uploads/2025-Child-Fatality-Prevention-System-Annual-Report\_FINAL-PUBLISHED.pdf](https://ncfrp.org/wp-content/uploads/2025-Child-Fatality-Prevention-System-Annual-Report_FINAL-PUBLISHED.pdf)  
24. Navajo Epidemiology Center Update, accessed February 27, 2026, [https://nec.navajo-nsn.gov/Portals/0/Reports/NEC%20Update%20FINAL%2010.15.24.pdf](https://nec.navajo-nsn.gov/Portals/0/Reports/NEC%20Update%20FINAL%2010.15.24.pdf)  
25. Alphabetical List of All Health Indicator Reports \- NM-IBIS, accessed February 27, 2026, [https://ibis.doh.nm.gov/indicator/index/Alphabetical.html](https://ibis.doh.nm.gov/indicator/index/Alphabetical.html)  
26. Health Rankings: Mountain West States, 2021 \- OAsis Research Repository \- University of Nevada, Las Vegas, accessed February 27, 2026, [https://oasis.library.unlv.edu/context/bmw\_lincy\_health/article/1015/viewcontent/Ahmed\_et\_al\_Health\_No.17\_Health\_Rankings\_in\_Mountain\_West\_States\_2021.pdf](https://oasis.library.unlv.edu/context/bmw_lincy_health/article/1015/viewcontent/Ahmed_et_al_Health_No.17_Health_Rankings_in_Mountain_West_States_2021.pdf)  
27. azdhs-budget-request-fy-24.pdf, accessed February 27, 2026, [https://www.azdhs.gov/documents/operations/financial-services/azdhs-budget-request-fy-24.pdf](https://www.azdhs.gov/documents/operations/financial-services/azdhs-budget-request-fy-24.pdf)  
28. DES-1352A 2024 Annual Report \- Arizona Department of Economic Security, accessed February 27, 2026, [https://des.az.gov/sites/default/files/dl/des\_annual\_report\_2024.pdf](https://des.az.gov/sites/default/files/dl/des_annual_report_2024.pdf)  
29. Utah Health Status Update, accessed February 27, 2026, [https://ibis.utah.gov/ibisph-view/pdf/opha/publication/hsu/2025/2502\_HPI.pdf](https://ibis.utah.gov/ibisph-view/pdf/opha/publication/hsu/2025/2502_HPI.pdf)  
30. CDPHE Open Data Portal | Colorado Information Marketplace, accessed February 27, 2026, [https://data.colorado.gov/State/CDPHE-Open-Data-Portal/2c44-7syn](https://data.colorado.gov/State/CDPHE-Open-Data-Portal/2c44-7syn)  
31. CDPHE Health Facilities | Colorado Information Marketplace, accessed February 27, 2026, [https://data.colorado.gov/Health/CDPHE-Health-Facilities/98pp-s4r4](https://data.colorado.gov/Health/CDPHE-Health-Facilities/98pp-s4r4)  
32. Data \- Colorado Consortium for Prescription Drug Abuse Prevention, accessed February 27, 2026, [https://corxconsortium.org/data/](https://corxconsortium.org/data/)  
33. Utah Open Data \- Utah.gov, accessed February 27, 2026, [https://opendata.utah.gov/](https://opendata.utah.gov/)  
34. State Open Data Policies and Portals \- Center for Data Innovation, accessed February 27, 2026, [https://datainnovation.org/2014/08/state-open-data-policies-and-portals/](https://datainnovation.org/2014/08/state-open-data-policies-and-portals/)  
35. NM-IBIS \- Welcome to IBIS-PH \-- Our State's Public Health Data ..., accessed February 27, 2026, [https://ibis.doh.nm.gov/](https://ibis.doh.nm.gov/)  
36. Financial Transparency Portal: Home, accessed February 27, 2026, [https://openbooks.az.gov/](https://openbooks.az.gov/)  
37. Expenditures \- Financial Transparency Portal, accessed February 27, 2026, [https://openbooks.az.gov/expenditures](https://openbooks.az.gov/expenditures)  
38. Arizona Financial Transparency Portal / Reporting \- opengov, accessed February 27, 2026, [https://controlpanel.opengov.com/transparency-reporting/az/cbc89011-9082-4045-bcb1-3dc86eac9543/28034cfc-ed5f-4110-9609-957202079bc4?savedViewId=71fffeeb-1816-46fa-8725-087176b386ca](https://controlpanel.opengov.com/transparency-reporting/az/cbc89011-9082-4045-bcb1-3dc86eac9543/28034cfc-ed5f-4110-9609-957202079bc4?savedViewId=71fffeeb-1816-46fa-8725-087176b386ca)  
39. Public Health Data Portal \- PHDP \- Arizona Department of Health Services, accessed February 27, 2026, [https://data.azdhs.gov/](https://data.azdhs.gov/)  
40. Search Data Assets \- Public Health Data Portal \- Arizona Department of Health Services, accessed February 27, 2026, [https://data.azdhs.gov/data-assets/search-data](https://data.azdhs.gov/data-assets/search-data)  
41. Dataset-specific Resources for NM-IBIS Query System Datasets, accessed February 27, 2026, [https://ibis.doh.nm.gov/resource/DatasetSpecific.html](https://ibis.doh.nm.gov/resource/DatasetSpecific.html)  
42. Disparities | Fact Sheets \- Indian Health Service (IHS), accessed February 27, 2026, [https://www.ihs.gov/newsroom/factsheets/disparities/](https://www.ihs.gov/newsroom/factsheets/disparities/)  
43. Healthcare access, attitudes and behaviours among Navajo adults during the COVID-19 pandemic: a cross-sectional study \- PMC, accessed February 27, 2026, [https://pmc.ncbi.nlm.nih.gov/articles/PMC11636652/](https://pmc.ncbi.nlm.nih.gov/articles/PMC11636652/)  
44. IHS FY 2024 Justification of Estimates for Appropriations Committees, accessed February 27, 2026, [https://www.ihs.gov/sites/ofa/themes/responsive2017/display\_objects/documents/FY2024-IHS-CJ32223.pdf](https://www.ihs.gov/sites/ofa/themes/responsive2017/display_objects/documents/FY2024-IHS-CJ32223.pdf)  
45. Special Diabetes Program for Indians (SDPI) | Indian Health Service ..., accessed February 27, 2026, [https://www.ihs.gov/sdpi/](https://www.ihs.gov/sdpi/)  
46. Statement from IHS Director Roselyn Tso on the President's Fiscal Year 2025 Budget, accessed February 27, 2026, [https://www.ihs.gov/newsroom/pressreleases/2024-press-releases/statement-from-ihs-director-roselyn-tso-on-the-presidents-fiscal-year-2025-budget/](https://www.ihs.gov/newsroom/pressreleases/2024-press-releases/statement-from-ihs-director-roselyn-tso-on-the-presidents-fiscal-year-2025-budget/)  
47. Advancing Health Equity Through the Federal Trust Responsibility:, accessed February 27, 2026, [https://www.nihb.org/wp-content/uploads/2025/01/FY-2024-Tribal-Budget-Formulation-Workgroup-Recommendations.pdf](https://www.nihb.org/wp-content/uploads/2025/01/FY-2024-Tribal-Budget-Formulation-Workgroup-Recommendations.pdf)  
48. Navajo Epidemiology Center, accessed February 27, 2026, [https://tribalepicenters.org/navajo-epidemiology-center/](https://tribalepicenters.org/navajo-epidemiology-center/)  
49. Public Health Authority & the Importance of Data | Tribal Epidemiology Centers, accessed February 27, 2026, [https://tribalepicenters.org/public-health-authority-the-importance-of-data/](https://tribalepicenters.org/public-health-authority-the-importance-of-data/)  
50. Cancer Data Dashboard \- Navajo Nation, accessed February 27, 2026, [https://nec.navajo-nsn.gov/Data-Dashboard/Cancer](https://nec.navajo-nsn.gov/Data-Dashboard/Cancer)  
51. Navajo Epidemiology Center, accessed February 27, 2026, [https://nec.navajo-nsn.gov/](https://nec.navajo-nsn.gov/)  
52. South Africa \- WHO Data, accessed February 27, 2026, [https://data.who.int/countries/710](https://data.who.int/countries/710)  
53. Inside the Numbers: SA Population Trends for 2025 | Statistics South Africa, accessed February 27, 2026, [https://www.statssa.gov.za/?p=18613](https://www.statssa.gov.za/?p=18613)  
54. HIV and TB Overview: South Africa \- CDC, accessed February 27, 2026, [https://www.cdc.gov/global-hiv-tb/php/where-we-work/southafrica.html](https://www.cdc.gov/global-hiv-tb/php/where-we-work/southafrica.html)  
55. The costs of interventions for type 2 diabetes mellitus, hypertension and cardiovascular disease in South Africa – a systematic literature review \- PMC, accessed February 27, 2026, [https://pmc.ncbi.nlm.nih.gov/articles/PMC9743545/](https://pmc.ncbi.nlm.nih.gov/articles/PMC9743545/)  
56. The latest breakdown of South African government spending, accessed February 27, 2026, [https://www.statssa.gov.za/?p=19013](https://www.statssa.gov.za/?p=19013)  
57. Mortality and causes of death in South Africa: Findings from death notification \- Spotlight, accessed February 27, 2026, [https://www.spotlightnsp.co.za/wp-content/uploads/2025/11/mortality-and-causes-of-death-in-south-africa-2020.pdf](https://www.spotlightnsp.co.za/wp-content/uploads/2025/11/mortality-and-causes-of-death-in-south-africa-2020.pdf)  
58. Mortality and causes of death in South Africa: Findings from death notification, accessed February 27, 2026, [https://www.statssa.gov.za/publications/P03093/P030932022.pdf](https://www.statssa.gov.za/publications/P03093/P030932022.pdf)  
59. Stats in Brief, 2025 \- Statistics South Africa, accessed February 27, 2026, [https://www.statssa.gov.za/publications/StatsInBrief/StatsInBrief2025.pdf](https://www.statssa.gov.za/publications/StatsInBrief/StatsInBrief2025.pdf)  
60. Health \- Vulekamali, accessed February 27, 2026, [https://vulekamali.gov.za/2025-26/national/departments/health/](https://vulekamali.gov.za/2025-26/national/departments/health/)