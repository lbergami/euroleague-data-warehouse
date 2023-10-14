# Drazen - Euroleague basketball game reports
Drazen is an end-to-end project which produces a report for each Euroleague basketball game played during 2008 - 2023. 
Data are scrapped from three separate sources of the Euroleague website (play-by-play, box scores, and shot locations). The tools used include Python, Bigquery, DBT, and Looker Studio.

## Architecture 

### Overview

* Python scripts extract the data from the Euroleague website and load them on Google Storage buckets.
* Bigquery is used as cloud data warehouse.
* DBT is used for data transformations, testing, and data model documentation.
* Looker Studio is used for data visualization and hosts the final dashboard.

