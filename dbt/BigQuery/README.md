# Coding Conventions 

## General 

* Use lower case for all keywords.
* Use trailing commas in *select* statements.
* Use consistent style in *group by* and *order by* (either names or numbers, not both).
* Use SQLFluff's default linting rules to format *select* statements (models and tests).

<p> <br>

# Testing Conventions

Setting the convensions listed below for staging and marts to ensure good test coverage and 
to avoid redundancy as the project scales up.

## Staging models 

* The primary key source column must have *not_null* and *unique* schema tests.
* All boolean columns must have an *accepted_values* schema test. The accepted values are true and false.
* Columns that contain category values must have an *accepted_values* schema test.
* Columns that should never be null must have a *not_null* schema test.
* Columns that should be unique must have a *unique* schema test.
* Columns that are numeric and that cannot have negative values should have an assetion test to check positivity.
* No other tests are required at the staging level since transformations are only limited to (i) renaming, (ii) type casting, and (iii) basic computations.
* With the exception of the two schema test imposed on the primary keys, points above only applies to columns that are used in the downstream models

## Data Marts

* When a dim/fact has only one source, there is no need to perform schema or assertion tests on columns that 
  are not affected by the transformation, with the exception of the primary key column which have *not_null* and *unique* test.

* When a dim/fact table is the outcome of a number of (left) joins of multiple tables and no other operations are 
  performed, there is not need to perform schema or assertion tests on columns that are coming from the ‘anchor’ table, 
  with the following exception:
  * The primary key column must have *not_null* and *unique* tests.
  * Key columns from the joined table(s) must have a *not_null* test, if it is required.

* Otherwise on columns created in the transformation:
    * All boolean columns must have an *accepted_values* schema test. The accepted values are true and false.
    * Columns that contain category values must have an *accepted_values* schema test.
    * Columns that should never be null must have a *not_null* schema test.
    * Columns that should be unique must have a *unique* schema test.
    * Columns that are numeric and that cannot have negative values should have an assetion test to check positivity.

* Data models that feed into the dashboard must have the prefix *'rpt_'* (reporting models), to distinguish them from upstream models. 
  Given the limit number of transformations, tests are limited to:
    * An *accepted_values* schema test on the *season* column to confirm that reporting models include games from the 2023 season only.
    * A *unique* schema test on the combination of *season* and *game_id*, when data granularity is at the game level.

<p> <br>

# Other Conventions 

* The primary keys of the source data are created as last step of the extracting process, before loading the data into google storage buckets.

* Staging models have been originally materialized as *tables* (data for seasons 2008 - 2022). They have been turned to *increamental* models, since 2023 games data.

* Data models documentation is saved in a separate subfolder (*docs*) within the *models* directory and its structure mirrors the *marts* one to help the navigation. 
