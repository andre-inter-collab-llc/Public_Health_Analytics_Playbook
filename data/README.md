# Data

Downloaded datasets and extracted data files used in analyses. Organized by jurisdiction.

## Structure

```
data/
├── global/        # WHO, IHME, World Bank datasets
├── usa/           # CDC, USAspending datasets
├── four-corners/  # State-level datasets (AZ, CO, NM, UT)
├── navajo-nation/ # NEC reports and extracted data
└── south-africa/  # Stats SA, Vulekamali, NICD data
```

## Note

Large data files should not be committed to Git. Use `.gitignore` to exclude raw data downloads. Document the data source and retrieval method in the analysis scripts.
