Project Overview
This project demonstrates a full-stack data workflow, transforming raw retail data into business intelligence by bridging Python and SQL. I managed the entire lifecycle: from cleaning "messy" data and feature engineering in Jupyter to performing complex customer segmentation and revenue attribution in a relational database.

Technical Execution

Data Engineering (Python): Cleaned 3,900 customer records using Pandas. I handled missing values in 'Review Rating' via median grouping by category and standardized column names for database compatibility.
Feature Engineering: Created an 'age_group' column using quartile binning and mapped purchase frequencies to numerical day values to enable time-series analysis.
Database Pipeline: Established a connection to MySQL using SQLAlchemy. I automated the data migration from a Python DataFrame to a structured SQL table, resolving schema mismatches during the process.
Advanced SQL Analytics: Developed production-ready scripts utilising Common Table Expressions (CTEs) and Window Functions to extract deep business metrics.

Key Business Insights

Customer Loyalty: Segmented the user base into 3,116 Loyal, 701 Returning, and 83 New customers.
Revenue Drivers: Male shoppers contribute significantly more revenue ($157,890) compared to Female shoppers ($75,191).
Seasonal Trends: Identified Fall as the peak season with $60,018 in total sales.
Product Performance: Ranked Gloves (3.86) and Sandals (3.84) as the highest-rated products.
Marketing Efficiency: Found that Hats and Sneakers have the highest discount-utilisation rates, with nearly 50% of sales being promotion-driven.
Logistics Analysis: Noted that Express Shipping transactions have a higher average value ($60.48) than Standard Shipping ($58.46).
