# retail-erp-dbt-datapipeline
This project pulls data generated from https://github.com/gontay/retail-erp-simulator
It follows the medallion architecture.
The pipeline demonstrates how raw transactional ERP data can be incrementally transformed into analytics-ready datasets using layered data modeling practices commonly found in modern data platforms.

# Background
Retail ERP systems generate operational data across multiple business domains such as:

sales
inventory
procurement
customers
suppliers
payments
fulfillment

In production environments, this data is often:

fragmented across systems
inconsistent in quality
difficult to analyze directly
unsuitable for downstream reporting without transformation

This project was created to:

explore modern analytics engineering workflows
practice layered data modeling
implement medallion architecture concepts
gain hands-on exposure to dbt transformation workflows
simulate realistic enterprise-style data pipelines

The project focuses on transforming operational ERP data into structured analytical models suitable for:

reporting
KPI tracking
operational analysis
downstream BI tooling

# Methodology

## Medallion Architecture
The pipeline follows a medallion architecture design pattern:
```
Raw Source Data
      ↓
Bronze Layer
      ↓
Silver Layer
      ↓
Gold Layer
```
This architecture separates:

ingestion
cleansing
standardization
business modeling
analytics aggregation

into distinct transformation layers.
### Bronze
The Bronze layer is responsible for ingesting raw ERP operational data generated from the retail ERP simulator into the data platform with minimal transformation.

Data ingestion is handled using Databricks Auto Loader, which incrementally detects and processes new source files efficiently. This enables scalable ingestion workflows while maintaining source data fidelity and supporting schema evolution over time.

Key characteristics of the Bronze layer:

Raw source data ingestion using Databricks Auto Loader
Incremental file detection and loading
Minimal transformation during ingestion
Source schema preservation
Historical data retention for traceability and reproducibility

The Bronze layer acts as the system-of-record landing zone for all downstream transformations.

### Silver

The Silver layer standardizes, cleanses, and transforms raw Bronze datasets into structured canonical business models.

Transformations in this layer are implemented using dbt, enabling modular SQL-based transformation workflows and dependency management.

Typical Silver layer transformations include:

data type normalization
null handling
deduplication
timestamp standardization
referential integrity checks
status normalization
entity relationship modeling

The purpose of the Silver layer is to improve data quality and create reusable operational models that can serve as the foundation for downstream analytics.

dbt is used to:

manage transformation dependencies
structure modular SQL models
enforce transformation consistency
improve maintainability and reproducibility

### Gold

The Gold layer contains business-oriented analytical models optimized for reporting, KPI tracking, and downstream business intelligence use cases.

This layer is also implemented using dbt, where curated business marts and aggregated analytical datasets are built on top of Silver layer models.

Typical Gold layer outputs include:

sales performance summaries
customer purchasing behavior analysis
inventory turnover metrics
supplier performance analysis
operational KPI dashboards

The Gold layer transforms operational ERP data into analytics-ready datasets suitable for:

dashboarding
executive reporting
business performance monitoring
decision support systems

## dbt

Using dbt for both Silver and Gold layers enables:

clear lineage tracking
layered transformation architecture
reusable business logic
scalable analytics engineering workflows