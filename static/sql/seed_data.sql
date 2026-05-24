-- ============================================================
-- health_hub seed data
-- Populates lookup tables: gender, data_type, unit_of_measure
-- Run once, after table_ddl.sql, against database health_db.
-- ============================================================

-- ---------- gender ----------
INSERT INTO gender (gender) VALUES
    ('Female'),
    ('Male'),
    ('Other'),
    ('Prefer not to say'),
    ('Unknown')
ON CONFLICT (gender) DO NOTHING;

-- ---------- data_type ----------
-- These map an observation to the result column used in the
-- _biometrics / _vitals / _results fact tables.
INSERT INTO data_type (data_type) VALUES
    ('numeric'),
    ('smallint'),
    ('integer'),
    ('text'),
    ('boolean')
ON CONFLICT (data_type) DO NOTHING;

-- ---------- unit_of_measure ----------
-- (unit_of_measure, unit_of_measure_abbr, unit_of_measure_format)
INSERT INTO unit_of_measure (unit_of_measure, unit_of_measure_abbr, unit_of_measure_format) VALUES
    -- weight / body composition
    ('pounds',                     'lb',         '%0.1f'),
    ('kilograms',                  'kg',         '%0.2f'),
    ('grams',                      'g',          '%0.1f'),
    ('body mass index',            'BMI',        '%0.1f'),
    ('percent',                    '%',          '%0.1f'),

    -- height / length
    ('inches',                     'in',         '%0.1f'),
    ('centimeters',                'cm',         '%0.1f'),
    ('feet',                       'ft',         '%0.1f'),
    ('meters',                     'm',          '%0.2f'),

    -- vitals
    ('millimeters of mercury',     'mmHg',       '%d'),
    ('beats per minute',           'bpm',        '%d'),
    ('breaths per minute',         'br/min',     '%d'),
    ('degrees Fahrenheit',         'F',         '%0.1f'),
    ('degrees Celsius',            'C',         '%0.1f'),
    ('percent oxygen saturation',  'SpO2 %',     '%d'),

    -- lab results
    ('milligrams per deciliter',   'mg/dL',      '%0.2f'),
    ('grams per deciliter',        'g/dL',       '%0.2f'),
    ('millimoles per liter',       'mmol/L',     '%0.2f'),
    ('micromoles per liter',       'umol/L',     '%0.2f'),
    ('milliequivalents per liter', 'mEq/L',      '%0.1f'),
    ('international units per liter','IU/L',     '%0.1f'),
    ('units per liter',            'U/L',        '%0.1f'),
    ('nanograms per milliliter',   'ng/mL',      '%0.2f'),
    ('picograms per milliliter',   'pg/mL',      '%0.2f'),
    ('cells per microliter',       'cells/uL',   '%d'),
    ('thousand per microliter',    'K/uL',       '%0.1f'),
    ('million per microliter',     'M/uL',       '%0.2f'),
    ('femtoliters',                'fL',         '%0.1f'),
    ('picograms',                  'pg',         '%0.1f'),
    ('per high-power field',       '/hpf',       '%d'),
    ('ratio',                      'ratio',      '%0.2f'),

    -- medication
    ('milligrams',                 'mg',         '%0.2f'),
    ('micrograms',                 'mcg',        '%0.2f'),
    ('milliliters',                'mL',         '%0.2f'),
    ('international units',        'IU',         '%d'),
    ('tablet',                     'tab',        '%d'),
    ('capsule',                    'cap',        '%d'),
    ('drop',                       'gtt',        '%d'),
    ('puff',                       'puff',       '%d'),

    -- activity
    ('minutes',                    'min',        '%0.1f'),
    ('hours',                      'hr',         '%0.2f'),
    ('miles',                      'mi',         '%0.2f'),
    ('kilometers',                 'km',         '%0.2f'),
    ('steps',                      'steps',      '%d'),
    ('calories',                   'kcal',       '%d')
ON CONFLICT (unit_of_measure) DO NOTHING;

-- ---------- biometric_measure ----------
-- Uses lookup subqueries so we don't depend on serial IDs assigned above.
INSERT INTO biometric_measure (biometric_measure, data_type_id, unit_of_measure_id) VALUES
    ('height',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'numeric'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'inches')),
    ('weight',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'numeric'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'pounds')),
    ('bmi',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'numeric'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'body mass index')),
    ('body_fat_percentage',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'numeric'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'percent')),
    ('waist_circumference',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'numeric'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'inches'))
ON CONFLICT (biometric_measure) DO NOTHING;

-- ---------- vitals_measure ----------
-- Storage convention:
--   * Single-value smallint vitals  -> vitals_measure_smallint
--   * Single-value numeric vitals   -> vitals_measure_numeric
--   * Blood pressure is recorded as ONE row in patient_vitals, keyed by
--     vitals_measure = 'bp_systolic', with the systolic value in
--     vitals_measure_smallint and the diastolic value in
--     vitals_measure_2_smallint. The 'bp_diastolic' lookup row exists
--     primarily so the UI / reports can label and format the paired value.
INSERT INTO vitals_measure (vitals_measure, data_type_id, unit_of_measure_id) VALUES
    ('heart_rate',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'smallint'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'beats per minute')),
    ('bp_systolic',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'smallint'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'millimeters of mercury')),
    ('bp_diastolic',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'smallint'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'millimeters of mercury')),
    ('body_temperature',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'numeric'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'degrees Fahrenheit')),
    ('blood_oxygen',
        (SELECT data_type_id       FROM data_type       WHERE data_type       = 'smallint'),
        (SELECT unit_of_measure_id FROM unit_of_measure WHERE unit_of_measure = 'percent oxygen saturation'))
ON CONFLICT (vitals_measure) DO NOTHING;

-- ---------- activity_type ----------
INSERT INTO activity_type (activity_type) VALUES
    ('cardio'),
    ('strength'),
    ('flexibility'),
    ('balance'),
    ('sports')
ON CONFLICT (activity_type) DO NOTHING;

-- ---------- activity ----------
-- Each row resolves its activity_type via subquery so serial IDs don't matter.
INSERT INTO activity (activity, activity_type_id) VALUES
    -- cardio
    ('walking',                  (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('jogging',                  (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('running',                  (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('cycling',                  (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('swimming',                 (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('rowing',                   (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('hiking',                   (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('elliptical',               (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),
    ('stair climbing',           (SELECT activity_type_id FROM activity_type WHERE activity_type = 'cardio')),

    -- strength
    ('weight training',          (SELECT activity_type_id FROM activity_type WHERE activity_type = 'strength')),
    ('body weight training',     (SELECT activity_type_id FROM activity_type WHERE activity_type = 'strength')),
    ('resistance band training', (SELECT activity_type_id FROM activity_type WHERE activity_type = 'strength')),
    ('powerlifting',             (SELECT activity_type_id FROM activity_type WHERE activity_type = 'strength')),

    -- flexibility
    ('yoga',                     (SELECT activity_type_id FROM activity_type WHERE activity_type = 'flexibility')),
    ('stretching',               (SELECT activity_type_id FROM activity_type WHERE activity_type = 'flexibility')),
    ('pilates',                  (SELECT activity_type_id FROM activity_type WHERE activity_type = 'flexibility')),

    -- balance
    ('tai chi',                  (SELECT activity_type_id FROM activity_type WHERE activity_type = 'balance')),
    ('balance training',         (SELECT activity_type_id FROM activity_type WHERE activity_type = 'balance')),

    -- sports
    ('tennis',                   (SELECT activity_type_id FROM activity_type WHERE activity_type = 'sports')),
    ('basketball',               (SELECT activity_type_id FROM activity_type WHERE activity_type = 'sports')),
    ('soccer',                   (SELECT activity_type_id FROM activity_type WHERE activity_type = 'sports')),
    ('golf',                     (SELECT activity_type_id FROM activity_type WHERE activity_type = 'sports')),
    ('pickleball',               (SELECT activity_type_id FROM activity_type WHERE activity_type = 'sports'))
ON CONFLICT (activity) DO NOTHING;
