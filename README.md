# E-Commerce-Customer-Segmentation-RFM-Analysis
End-to-end E-Commerce Customer Segmentation and RFM Analysis using Python, SQL, and Power BI.

## Project Overview

This project analyzes e-commerce transaction data to understand customer purchasing behavior, identify high-value customers, and segment customers using **RFM (Recency, Frequency, Monetary) Analysis**.

The analysis was performed using **Python, SQL, and Power BI** to transform raw transaction data into meaningful business insights and customer segments.

## Tools Used

* Python — Data Cleaning and Exploratory Data Analysis
* SQL (MySQL) — Business Analysis and RFM Analysis
* Power BI — Dashboard and Data Visualization
* Jupyter Notebook
* Pandas, NumPy, Matplotlib, Seaborn

## Dataset

The dataset contains approximately **541,000 e-commerce transaction records** from **December 2010 to December 2011**.

Key columns include:

* InvoiceNo
* StockCode
* Description
* Quantity
* InvoiceDate
* UnitPrice
* CustomerID
* Country

## Data Cleaning

The dataset was cleaned and prepared in Python.

Key steps included:

* Removed records with missing Customer IDs
* Removed 5,525 duplicate records
* Removed 8,872 cancelled transactions
* Removed non-product StockCodes
* Prepared the cleaned data for further analysis

## Exploratory Data Analysis

EDA was performed to understand customer and sales behavior, including:

* Sales trends over time
* Top customers by revenue
* Top-selling products
* Revenue by country
* Monthly and day-of-week sales patterns
* Quantity distribution and outliers

## Pareto Analysis

Pareto analysis showed that:

* **26% of customers generated 80% of total revenue**
* **20% of products generated 80% of total revenue**

This shows that a relatively small group of customers and products contributes a large portion of the business revenue.

## SQL Business Analysis

SQL was used to answer business questions such as:

* Which products generate the most revenue?
* Which countries generate the most revenue?
* What is the Average Order Value?
* Who are the highest-value customers?
* Which customers have more than 5 orders?
* When did each customer make their most recent purchase?

## RFM Customer Segmentation

Customers were analyzed using:

* **Recency:** Days since the customer's most recent purchase
* **Frequency:** Number of unique orders
* **Monetary:** Total amount spent

Customers were scored and divided into four segments:

* High Value
* Loyal
* At-Risk
* Dormant

## Power BI Dashboard

A Power BI dashboard was created to visualize:

* Overall sales performance
* Customer segments
* Sales trends
* Customer purchasing behavior
* High-value and at-risk customers

  <img width="1308" height="798" alt="Customer_segment_dashboard_screenshot" src="https://github.com/user-attachments/assets/7bbba907-b92d-4f26-a4ca-010f2116afe1" />


## Key Business Recommendations

* Reward **High Value customers** with loyalty programs and exclusive offers.
* Use cross-selling and upselling strategies for **Loyal customers**.
* Target **At-Risk customers** with personalized promotions.
* Use win-back campaigns to re-engage **Dormant customers**.
* Focus marketing efforts on customers and products that contribute the majority of revenue.

## Key Findings

* 26% of customers contribute 80% of total revenue.
* 20% of products contribute 80% of total revenue.
* RFM segmentation helps identify valuable, loyal, at-risk, and dormant customers.
* Different customer segments require different marketing and retention strategies.

## Project Files

* Python/Jupyter Notebook — Data Cleaning & EDA
* SQL File — Business Analysis & RFM Segmentation
* Power BI File — Interactive Dashboard
* PowerPoint — Project Presentation

## Conclusion

This project demonstrates an end-to-end data analytics workflow using **Python, SQL, and Power BI**. The analysis transforms raw e-commerce transaction data into customer segments and actionable business recommendations that can support customer retention and targeted marketing strategies.
