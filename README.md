# retail-erp-dbt-datapipeline
This project pulls data generated from https://github.com/gontay/retail-erp-simulator
It follows the medallion architecture.
The pipeline demonstrates how raw transactional ERP data can be incrementally transformed into analytics-ready datasets using layered data modeling practices commonly found in modern data platforms.

# Background
Retail ERP systems generate operational data across domains such as:

- sales
- inventory
- procurement
- customers
- suppliers
- payments
- fulfillment

In real-world environments, this data is often fragmented, inconsistent, and not immediately suitable for analytics.

This project was built to:

practice analytics engineering workflows
implement medallion architecture concepts
gain hands-on experience with dbt
simulate enterprise-style data pipelines

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
This separates:

ingestion
cleansing
standardization
business modeling
analytics aggregation

This separates:

- ingestion
- cleansing
- standardization
- business modeling
- analytics aggregation

into distinct stages.
### Bronze
The Bronze layer ingests raw ERP data with minimal transformation.

Data ingestion is handled using Databricks Auto Loader for incremental file detection and scalable ingestion.

Key characteristics:

- raw data ingestion
- schema preservation
- incremental loading
- historical retention
- minimal transformation

The Bronze layer acts as the raw landing zone for downstream processing.

### Silver
The Silver layer cleanses and standardizes Bronze datasets into reusable business models.

Transformations are implemented using dbt.

Typical transformations:

- data type normalization
- deduplication
- null handling
- timestamp standardization
- referential integrity checks
- status normalization

Purpose:

- improve data quality
- create canonical operational models
- prepare datasets for analytics

### Gold
The Gold layer contains analytics-ready business models built on top of Silver datasets.

This layer is also implemented using dbt.

Typical outputs:

- sales performance metrics
- customer purchasing analysis
- inventory turnover metrics
- supplier performance summaries
- KPI reporting datasets

The Gold layer is optimized for:

- BI dashboards
- reporting
- operational analytics
- decision support

This enables a scalable and maintainable analytics engineering workflow.

## dbt
dbt is used to manage Silver and Gold transformations through:

- modular SQL models
- dependency management
- layered transformations
- reusable business logic
- lineage tracking

This enables a scalable and maintainable analytics engineering workflow.