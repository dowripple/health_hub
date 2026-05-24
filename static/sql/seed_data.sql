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
    ('Unknown');

-- ---------- data_type ----------
-- These map an observation to the result column used in the
-- _biometrics / _vitals / _results fact tables.
INSERT INTO data_type (data_type) VALUES
    ('numeric'),
    ('smallint'),
    ('integer'),
    ('text'),
    ('boolean');

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
    ('calories',                   'kcal',       '%d');
