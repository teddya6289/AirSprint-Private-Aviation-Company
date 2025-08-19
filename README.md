# AirSprint Aviation Project – Summary
The project focused on leveraging data-driven insights to support AirSprint Private Aviation’s operations and decision-making.
## Key Steps:
- **Business & Data Understanding**
Studied AirSprint’s business model, customers, and operational structure.
Explored dataset structure, relationships (primary/foreign keys), and business terminology.
- **ETL Process (Python & Apache Airflow)**
- **Extraction:** Imported datasets and retrieved flight data via Fl3xx API.
## Transformation:
- Data exploration and cleaning (formatting dates, handling nulls, removing duplicates).
- Structuring through normalization/denormalization for efficient retrieval.
- Data enrichment (adding missing flight records).
- Validation for accuracy, consistency, and compliance with business rules.
- Loading: Stored processed models into Oracle 19C database using Python OracleDB.
- Automation: Automated ETL pipeline with Apache Airflow.

## Database Development
Designed database objects and SQL scripts to support ETL and analysis.
## Visualization (Power BI)
- Integrated Oracle database with Power BI for real-time, scalable insights.
- Built reports using SQL views for performance and maintainability.

## Deliverables:
- SQL scripts (database objects)
- Python Jupyter ETL workflow
- Automated pipeline with Airflow
- Power BI dashboards for visualization
