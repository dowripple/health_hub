-- ============================================================
-- health_hub schema (PostgreSQL)
-- Generated from QuickDBD data model: static/images/QuickDBD-health_hub.svg
-- Run against a database called health_db.
-- ============================================================

-- ---------- lookup tables (no FKs) ----------

CREATE TABLE gender (
    gender_id   smallserial PRIMARY KEY,
    gender      text NOT NULL UNIQUE
);

CREATE TABLE data_type (
    data_type_id smallserial PRIMARY KEY,
    data_type    text NOT NULL UNIQUE
);

CREATE TABLE unit_of_measure (
    unit_of_measure_id      serial PRIMARY KEY,
    unit_of_measure         text NOT NULL UNIQUE,
    unit_of_measure_abbr    text,
    unit_of_measure_format  text
);

CREATE TABLE activity_type (
    activity_type_id smallserial PRIMARY KEY,
    activity_type    text NOT NULL UNIQUE
);

CREATE TABLE lab_test (
    test_id   serial PRIMARY KEY,
    test_name text NOT NULL UNIQUE
);

-- ---------- lookup tables with FKs ----------

CREATE TABLE biometric_measure (
    biometric_measure_id serial PRIMARY KEY,
    biometric_measure    text NOT NULL UNIQUE,
    data_type_id         integer REFERENCES data_type(data_type_id),
    unit_of_measure_id   integer REFERENCES unit_of_measure(unit_of_measure_id)
);

CREATE TABLE vitals_measure (
    vitals_measure_id  serial PRIMARY KEY,
    vitals_measure     text NOT NULL UNIQUE,
    data_type_id       integer REFERENCES data_type(data_type_id),
    unit_of_measure_id integer REFERENCES unit_of_measure(unit_of_measure_id)
);

CREATE TABLE medication (
    medication_id      serial PRIMARY KEY,
    medication         text NOT NULL UNIQUE,
    unit_of_measure_id integer REFERENCES unit_of_measure(unit_of_measure_id)
);

CREATE TABLE lab_component (
    component_id       serial PRIMARY KEY,
    component_name     text NOT NULL UNIQUE,
    unit_of_measure_id integer REFERENCES unit_of_measure(unit_of_measure_id),
    data_type_id       integer REFERENCES data_type(data_type_id)
);

CREATE TABLE activity (
    activity_id      serial PRIMARY KEY,
    activity         text NOT NULL UNIQUE,
    activity_type_id smallint REFERENCES activity_type(activity_type_id)
);

-- ---------- core entity ----------

CREATE TABLE patient (
    patient_id   serial PRIMARY KEY,
    patient_name text NOT NULL,
    dob          date,
    gender_id    smallint REFERENCES gender(gender_id)
);

-- ---------- bridge ----------

CREATE TABLE lab_test_component (
    test_id      integer NOT NULL REFERENCES lab_test(test_id),
    component_id integer NOT NULL REFERENCES lab_component(component_id),
    PRIMARY KEY (test_id, component_id)
);

-- ---------- fact / observation tables ----------

CREATE TABLE patient_biometrics (
    observation_date           timestamp NOT NULL,
    patient_id                 integer   NOT NULL REFERENCES patient(patient_id),
    biometric_measure_id       integer   NOT NULL REFERENCES biometric_measure(biometric_measure_id),
    biometric_measure_numeric  numeric(18,4),
    biometric_measure_smallint smallint,
    biometric_measure_integer  integer,
    biometric_comment          text,
    created_datetime           timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (observation_date, patient_id, biometric_measure_id)
);

CREATE TABLE patient_vitals (
    observation_datetime       timestamp NOT NULL,
    patient_id                 integer   NOT NULL REFERENCES patient(patient_id),
    vitals_measure_id          integer   NOT NULL REFERENCES vitals_measure(vitals_measure_id),
    vitals_measure_numeric     numeric(8,4),
    vitals_measure_smallint    smallint,
    vitals_measure_integer     integer,
    vitals_measure_2_smallint  smallint,
    vitals_comment             text,
    created_datetime           timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (observation_datetime, patient_id, vitals_measure_id)
);

CREATE TABLE patient_medication (
    patient_id              integer   NOT NULL REFERENCES patient(patient_id),
    medication_id           integer   NOT NULL REFERENCES medication(medication_id),
    start_date              timestamp NOT NULL,
    end_date                timestamp,
    dosage_amount           numeric(18,4),
    prescription_condition  text,
    prescribed_by           text,
    medication_comment      text,
    PRIMARY KEY (patient_id, medication_id, start_date)
);

CREATE TABLE lab_test_component_results (
    patient_id               integer   NOT NULL REFERENCES patient(patient_id),
    component_id             integer   NOT NULL REFERENCES lab_component(component_id),
    result_datetime          timestamp NOT NULL,
    collection_datetime      timestamp,
    component_result_text    text,
    component_result_numeric numeric(18,4),
    component_result_smallint smallint,
    component_result_integer integer,
    abnormal_yn              boolean,
    result_comment           text,
    PRIMARY KEY (patient_id, component_id, result_datetime)
);

CREATE TABLE patient_activity (
    patient_id        integer   NOT NULL REFERENCES patient(patient_id),
    activity_id       integer   NOT NULL REFERENCES activity(activity_id),
    activity_datetime timestamp NOT NULL,
    activity_duration numeric(18,4),
    activity_distance numeric(18,4),
    activity_comment  text,
    PRIMARY KEY (patient_id, activity_id, activity_datetime)
);

-- ---------- helpful indexes on FK columns used in joins ----------

CREATE INDEX idx_patient_biometrics_patient    ON patient_biometrics (patient_id);
CREATE INDEX idx_patient_vitals_patient        ON patient_vitals (patient_id);
CREATE INDEX idx_patient_medication_patient    ON patient_medication (patient_id);
CREATE INDEX idx_lab_results_patient           ON lab_test_component_results (patient_id);
CREATE INDEX idx_patient_activity_patient      ON patient_activity (patient_id);
