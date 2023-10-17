# Drazen - Euroleague basketball game reports
Drazen is an end-to-end project which generates a report for each Euroleague basketball game played since the 2007-2008 season to explore teams' key performance indicators.
Data are scraped from three separate sources of the Euroleague website (play-by-play, box scores, and shot locations). The tools used are: Python, Google Storage & Bigquery, dbt, and Looker Studio.


![GitHub Logo](img/game_report_dashboard.PNG)



## Architecture 

### Tools

* Python scripts extract the data from the Euroleague website, perform some data cleaning steps and add additional variables. They then load final tables on Google Storage buckets.
* Bigquery is used as cloud data warehouse.
* dbt is used for data transformations, testing, and data models documentation.
* Looker Studio is used for data visualization and hosts the final dashboard.

### Data pipeline overview
![GitHub Logo](img/data_pipeline_overview.PNG)

### dbt Models 
* dbt is used as transformation layer. Coding and testing convensions are set out [here](./dbt/BigQuery/README.md).
* The documentation for this project can be accessed from this [link](https://ephemeral-blini-272893.netlify.app), while the DAG is reported below.

##### Lineage Graph
![GitHub Logo](img/dbt_dag.PNG)


## Next steps 
* Add 2023-2024 games as the current season progresses.
* Add a data orchestration method (currently exploring dagster cloud)


## Sources 
*  Game factors
	* [Basketball Reference](https://www.basketball-reference.com/about/glossary.html)
	* [Hack a stat](https://hackastat.eu/en/glossary/)
*  Shooting Areas
	* [82Games.com](https://www.82games.com/shotzones.htm)
* The court chart is creating amending the *plotShotchart.R* function from the [eurolig](https://github.com/solmos/eurolig) *R* Package. Shot locations data are then rescaled following the same 
  calculations. 
* The design of the dashboard took the work of Clement Recaud as reference

