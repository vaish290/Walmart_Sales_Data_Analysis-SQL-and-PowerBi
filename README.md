# 🛒 Walmart Sales Analysis Using SQL And PowerBi

## 📖 Overview
This project analyzes **Walmart sales data** to uncover insights into **revenue trends, product sales, and regional performance**.  

The analysis includes **data preprocessing, SQL queries, Power BI visualizations, and Python-based data exploration**.

## 🚀 Features
✅ **Data Cleaning & Preprocessing** – Handling missing values, formatting, and structuring data.  
✅ **SQL-Based Analysis** – Using queries to extract insights on sales trends.  
✅ **Power BI Dashboard** – Visualizing key metrics like revenue trends and best-selling products.  
✅ **Exploratory Data Analysis (EDA)** – Statistical insights using Python (Pandas, Seaborn, Matplotlib).  
✅ **Geospatial Analysis** – Evaluating store performance across different locations.  


## 🛠️ Tools & Technologies Used

This project utilizes a combination of data processing, visualization, and database management tools to extract valuable insights.

📌 Data Processing & Analysis

🐍 Python – Used for data analysis and manipulation.

📊 Pandas – For data cleaning, transformation, and exploration.

📈 Matplotlib & Seaborn – For creating visualizations and statistical analysis.

🛢️ Database & Querying

🐘 PostgreSQL – Used for querying and analyzing Walmart sales data.

🔍 SQL (Structured Query Language) – Used for data extraction, trend analysis, and revenue comparisons.

📊 Business Intelligence & Visualization

📉 Power BI – Used to create interactive dashboards and visualizations.

📍 Geospatial Analysis – Used for mapping sales trends across different cities.



## 📈 Key Insights from Analysis - SQL

1️⃣ Total Sales & Payment Methods

🔹 Identifying Popular Payment Methods

            SELECT DISTINCT(payment_method), COUNT(*), SUM(quantity) 
            FROM walmart 
            GROUP BY payment_method;
            
Credit Card is the most commonly used payment method.

E-wallet transactions are increasing, showing a shift towards digital payments.

Cash transactions are the least used, possibly indicating customer preference for non-cash methods.

Helps Walmart optimize payment processing strategies.


2️⃣ Best Rated Product Categories in Each Branch

🔹 Finding the Highest Rated Product Per Branch

        SELECT * 
        FROM (
            SELECT branch, category, AVG(rating), 
                   RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
            FROM walmart
            GROUP BY branch, category
        ) 
        WHERE rank=1;
        
Each branch has a top-performing product category based on customer ratings.

Categories like Electronics and Groceries often receive the highest ratings.

Helps in targeted promotions and marketing strategies.


3️⃣ Busiest Shopping Days for Each Branch

🔹 Which Days Have the Most Sales per Branch?

      SELECT * 
      FROM (
          SELECT branch,
                 TO_CHAR(TO_DATE(date, 'dd/mm/yy'), 'day') AS days, COUNT(*),
                 RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
          FROM walmart
          GROUP BY branch, days
          ORDER BY branch, COUNT(*) DESC
      )
      WHERE rank=1;
      
Certain days of the week have higher sales in different branches.

Weekends tend to have higher sales.

Helps Walmart optimize workforce allocation & inventory stocking.

4️⃣ Sales Volume & Quantity Sold by Payment Method

🔹 Which Payment Method Drives the Most Sales?

      SELECT payment_method, COUNT(*), SUM(quantity)
      FROM walmart
      GROUP BY payment_method;
      
Credit cards process the highest number of transactions.

Cash transactions are the least used.

E-wallet usage is growing, indicating a shift toward digital payments.

Helps Walmart optimize its payment options and promotional offers.

5️⃣ City-Wise Product Performance

🔹 Category Ratings Per City

    SELECT city, category, AVG(rating) AS average_rating, 
           MIN(rating) AS min_rating, MAX(rating) AS max_rating
    FROM walmart
    GROUP BY city, category;
    
Identifies top-performing product categories in each city.

Some cities have higher-rated products than others, possibly due to local preferences.

Helps in customized product offerings based on regional demand.

6️⃣ Category-Wise Revenue & Profit

🔹 Revenue vs. Profitability per Product Category

    SELECT category, SUM(total) AS total_revenue, 
           SUM(unit_price * quantity * profit_margin) AS total_profit
    FROM walmart
    GROUP BY category
    ORDER BY total_profit DESC;

Categories with the highest revenue may not have the highest profit margins.

Helps Walmart prioritize high-margin product categories for promotions.

7️⃣ Most Preferred Payment Method Per Branch

🔹 Finding the Most Used Payment Method for Each Branch

      SELECT * 
      FROM (
          SELECT branch, COUNT(payment_method), payment_method,
                 RANK() OVER(PARTITION BY branch ORDER BY COUNT(payment_method) DESC)
          FROM walmart 
          GROUP BY branch, payment_method
          ORDER BY branch, COUNT(payment_method) DESC
      )
      WHERE rank=1;
      
Each branch has a preferred payment method.

Helps Walmart optimize point-of-sale systems and customer experience.


8️⃣ Peak Shopping Hours by Shift

🔹 Dividing Sales into Morning, Afternoon, and Evening Shifts

    SELECT COUNT(*), branch,
           CASE 
              WHEN EXTRACT(HOUR FROM (time::time)) < 12 THEN 'Morning'
              WHEN EXTRACT(HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
              ELSE 'Evening'
           END AS shifts
    FROM walmart
    GROUP BY shifts, branch;

Afternoon is the busiest shift, followed by the Evening.

Helps Walmart adjust staffing schedules for high-demand hours.

9️⃣ Yearly Revenue Comparison (2022 vs 2023)

🔹 Finding Branches with Declining Revenue

    WITH revenue_2022 AS (
        SELECT branch, SUM(total) AS revenue
        FROM walmart
        WHERE EXTRACT(YEAR FROM TO_DATE(date, 'dd/mm/yy')) = 2022
        GROUP BY branch
    ),
    revenue_2023 AS (
        SELECT branch, SUM(total) AS revenue
        FROM walmart
        WHERE EXTRACT(YEAR FROM TO_DATE(date, 'dd/mm/yy')) = 2023
        GROUP BY branch
    )
    SELECT ls.branch, ls.revenue AS ls_revenue, cs.revenue AS cs_revenue, 
           ROUND((ls.revenue - cs.revenue)::NUMERIC / ls.revenue::NUMERIC * 100, 2) AS ratio
    FROM revenue_2022 AS ls
    JOIN revenue_2023 AS cs ON ls.branch = cs.branch
    WHERE ls.revenue > cs.revenue
    ORDER BY ratio DESC
    LIMIT 5;
    
Identifies branches where revenue has declined from 2022 to 2023.

Helps Walmart determine which locations need new marketing strategies.

🔟 Branches with the Highest Revenue Decline (2022 vs 2023)

🔹 Finding the Top 5 Branches with the Most Revenue Drop

    SELECT ls.branch, 
           ls.revenue AS ls_revenue, 
           cs.revenue AS cs_revenue, 
           ROUND((ls.revenue - cs.revenue)::NUMERIC / ls.revenue::NUMERIC * 100, 2) AS ratio
    FROM revenue_2022 AS ls
    JOIN revenue_2023 AS cs ON ls.branch = cs.branch
    WHERE ls.revenue > cs.revenue
    ORDER BY ratio DESC
    LIMIT 5;

This query compares the revenue of each branch in 2022 vs. 2023.

Branches where 2023 revenue is lower than 2022 are considered.

The query calculates the percentage drop in revenue for each branch.

The top 5 branches with the highest revenue decline are displayed.

## 📈 Key Insights from Analysis - PowerBi

![image](https://github.com/user-attachments/assets/e8621afb-c012-4147-9bcf-3078f75ecc3c)


This Power BI dashboard provides insights into sales transactions, profit margins, branch performance, and payment methods.

1️⃣ Total Transactions Overview

Total Invoice Count: 9969 transactions

This metric represents the total number of sales transactions processed.

It provides a high-level view of sales volume over a specific period.

2️⃣ Payment Method Analysis

The dashboard includes filters for Cash, Credit Card, and E-wallet transactions.

Credit cards are likely the most preferred mode of payment.

E-wallets show significant usage, indicating growing digital payment adoption.

Helps Walmart in:

Optimizing digital payment processing.

Encouraging e-wallet adoption through discounts.

Assessing branch-wise payment trends.

3️⃣ Branch Distribution Across Cities

The “Count of Branch by City” visualization shows how many branches exist in each city.

Weslaco & Waxahachie have the highest number of Walmart branches.

Other key cities include:

Port Arthur

Plano

Richardson

Cities with higher branch counts likely generate more revenue and require higher inventory management efforts.

4️⃣ Profit Margin Trends Over Time

"Average of Profit Margin by Time" visualizes profit fluctuations throughout the day.

Profit margins appear to be relatively stable, but fluctuations exist at different time intervals.

Observations:

Some dips in profit margin suggest times of lower-margin sales (e.g., discount periods).

Evening hours show increasing profit margin, possibly due to high sales volumes.

Business Impact:

Walmart can identify peak profit-generating hours and adjust pricing strategies accordingly.

Helps in monitoring profitability trends for different shifts (morning, afternoon, evening).

5️⃣ Profit Margins by Day & Branch Performance

The "Average of Profit Margin by Day Name and Branch" visualization compares branch-wise profit performance.

Profit margins remain stable across different days, suggesting consistent pricing strategies.

Insights for Walmart:

If certain days have higher profit margins, they could indicate successful promotional campaigns.

If profit margins dip on specific days, Walmart can analyze customer behavior & optimize pricing strategies.

💡 Key Takeaways from the Power BI Dashboard

✅ Credit Cards and E-wallets dominate as payment methods, while cash transactions are minimal.

✅ Weslaco & Waxahachie have the most Walmart branches, making them key revenue-generating cities.

✅ Profit margins fluctuate throughout the day, indicating potential impact from pricing strategies & discounts.

✅ Day-wise profit margin distribution shows consistency, meaning Walmart may have stable pricing models.

✅ Monitoring branch performance by profit margins helps in assessing store efficiency & profitability.




