# Health Hub

Track a patient's health stats over time — weight, vitals, lab results, medications, and more — all in one place. Built on a PostgreSQL database, Python Flask backend, and a jQuery / DataTables front end.

### Data Model

<p align="center">
  <img src="static/images/QuickDBD-health_hub.svg" alt="health_hub data model" width="100%">
</p>

### Screenshots
_TBD — once the UI is built out._

### Tools Needed to Create
|Tool   |Description                                                                                                          |
|-------|---------------------------------------------------------------------------------------------------------------------|
|PostgreSQL|Free relational database. [PostgreSQL](https://www.postgresql.org/)|
|Python|Flask + Waitress to serve the app; psycopg2 / SQLAlchemy for DB access|
|jQuery / DataTables|Front-end table rendering, filtering, and export ([DataTables](https://datatables.net/))|
|Bootstrap|UI styling|
|Plotly|Charts for trending lab values, weight, etc.|

### Steps to Create
|Step #|            |                                                                                                           |
|---|------------|-----------------------------------------------------------------------------------------------------------|
|1  |Install prerequisites|Run `install_prereqs.bat` to install PostgreSQL, Python, Git, and the GitHub CLI|
|2  |Setup PostgreSQL DB|Create a database called `health_db`|
|3  |Create tables|Run `static/sql/table_ddl.sql` to create the schema (see **Data Model** above)|
|4  |Load reference data|Run `static/sql/seed_data.sql` to populate the lookup tables (see **Pre-seeded Reference Data** below). Idempotent — safe to re-run.|
|5  |Configure connection|Add DB credentials / Flask secret to the app config|
|6  |Launch|Run `start_health_hub.bat` to start the Flask app via Waitress|

### Database
DDL lives in `static/sql/table_ddl.sql`; reference data in `static/sql/seed_data.sql`. Both should be run against the `health_db` database after creation.

### Pre-seeded Reference Data
Out of the box, `seed_data.sql` populates the lookup tables so the app has something to work with on day one. Every insert uses `ON CONFLICT DO NOTHING`, so the script is safe to re-run.

**Lookups**
- `gender` (5): Female, Male, Other, Prefer not to say, Unknown
- `data_type` (5): numeric, smallint, integer, text, boolean — selects which result column a measurement writes to in the fact tables
- `unit_of_measure` (~45): pounds, kg, inches, cm, mmHg, bpm, mg/dL, mmol/L, U/L, K/μL, M/μL, mg, mL, IU, miles, km, kcal, etc. Each row carries an abbreviation and a `printf`-style format string for display.

**Biometrics** (`biometric_measure`)
| measure | unit |
|---|---|
| height | inches |
| weight | pounds |
| bmi | BMI |
| body_fat_percentage | percent |
| waist_circumference | inches |

**Vitals** (`vitals_measure`)
| measure | unit |
|---|---|
| heart_rate | bpm |
| bp_systolic | mmHg |
| bp_diastolic | mmHg *(see note below)* |
| body_temperature | °F |
| blood_oxygen | SpO2 % |

> Blood pressure storage convention: a single row in `patient_vitals` keyed by `bp_systolic` holds systolic in `vitals_measure_smallint` and diastolic in `vitals_measure_2_smallint`. `bp_diastolic` exists primarily so the UI / reports can label the paired value.

**Activities** (`activity_type` + `activity`)

Categories (5): `cardio`, `strength`, `flexibility`, `balance`, `sports`

| category | activities |
|---|---|
| cardio | walking, jogging, running, cycling, swimming, rowing, hiking, elliptical, stair climbing |
| strength | weight training, body weight training, resistance band training, powerlifting |
| flexibility | yoga, stretching, pilates |
| balance | tai chi, balance training |
| sports | tennis, basketball, soccer, golf, pickleball |

**Lab Tests** (`lab_test` + `lab_component` + `lab_test_component`)

| test | # components | components |
|---|---|---|
| basic metabolic panel | 8 | glucose, calcium, sodium, potassium, bicarbonate, chloride, blood urea nitrogen, creatinine |
| comprehensive metabolic panel | 14 | BMP + albumin, total protein, alkaline phosphatase, alanine aminotransferase, aspartate aminotransferase, total bilirubin |
| lipid panel | 4 | total cholesterol, ldl cholesterol, hdl cholesterol, triglycerides |
| complete blood count | 9 | white blood cell count, red blood cell count, hemoglobin, hematocrit, mean corpuscular volume, mean corpuscular hemoglobin, mean corpuscular hemoglobin concentration, platelet count, red cell distribution width |
| hemoglobin a1c | 1 | hemoglobin a1c |

**Not yet seeded** — these tables exist but are populated by the app (or future seeds): `medication`, `patient`, and all `patient_*` fact tables.
