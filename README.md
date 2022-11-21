## Real Estate Project - Municipality Screener
---

[Link to Power BI dashboard](https://app.powerbi.com/view?r=eyJrIjoiYWMxMWVkOWItMzg5Yy00YzU5LWFkNjAtMjM2NmQ5NzFmMDFmIiwidCI6IjU3YTZkZmMxLTI3MWUtNDIyNS1hYTMzLTFkNGM2ZmVhNjYxYSIsImMiOjh9)

[Link to SQL code in GitHub](https://github.com/ThomasDanford/RealEstateProject/blob/main/SQL_queries.sql)

---

### Summary

* Purpose: **help identify municipalities in Finland that may show investment potential in residential real estate**
* It uses demographic data to create four municipality rankings - income, jobs, population & overall - based on their 5-year growth (2015-2020)
* These are paired with the change in prices over the same period, and can be used to identify potential areas where prices may not have yet reacted to positive demographic development

---

### How it was built

The data was collected from Tilastokeskus, stored in a MySQL database, queried using DBeaver and visualized in PowerBI.

Key steps in analysis:
* Cleaning and restructuringoriginal data in SQL for best usability in visualization
* Selecting the most suitable metrics to represent demographic categories
* Creating the category rankings in SQL based on demographic data
* Determining the best and most logical presentation method
* Building the final visualizations in Power BI

### 1. Exploratory Plot

* A quick glance of demographic changes and price changes in one chart
* Choose a ranking category for the y-axis and filter based on population or real estate type to find potential areas
* Results are limited to the top-50 in each ranking category

### 2. Municipality Look-up

* Once you have identified interesting areas from the plot chart, use this page to look deeper into details about those areas
* Shows how the three sub-categories impact the overall ranking, along with how the price change compares to the national average

### 3. Data Table

* View the data in depth and see category rankings beyond the top-50
* Filter based on population and real estate type
* Can be useful to find areas overlooked in the exploratory plot due to missing price information or areas with rankings just beyond the top-50
