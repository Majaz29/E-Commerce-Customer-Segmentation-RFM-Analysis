USE customer_segmentation;
show databases;
select * from sales;

-- 1. How many total transactions/orders are in the dataset?
 select count(*) as total_transactions
 from sales;
 -- 2. How many unique customers do we have?
 select count(distinct CustomerID) as unique_customer from sales;
 -- 3. How many unique products are sold?
  select count(distinct StockCode) as unique_products from sales;
  -- 4. Which countries have the highest number of customers?
    select country,count(distinct CustomerID) as customers
    from sales
    group by country
    order by customers desc;
    
  -- 5. Which countries generate the most revenue?
      select country, round(sum(total_sales),2) as revenue
      from sales
      group by country
      order by revenue desc;
  

-- 6. What are the top 10 products by total revenue-- 
 select StockCode as top_10_products, Description,sum(Total_sales) as revenue
 from sales 
 group by StockCode,Description
 order by revenue desc
 limit 10;

-- 7. What are the top 10 products by quantity sold?
   select StockCode as products,Description,sum(Quantity) as quantity_sold
   from sales
   group by StockCode,Description
   order by quantity_sold desc
   limit 10;


-- 8. Which month generated the highest revenue?
      select month(InvoiceDate) as month,year(InvoiceDate) as year,sum(Total_sales) as highest_revenue_genarator_month
      from sales
      group by month(InvoiceDate),year(InvoiceDate)
      order by highest_revenue_genarator_month;

-- 9. What is the average order value?
       select avg(order_total) as avg_order_value
        from(select InvoiceNo,sum(Total_sales) as order_total
        from sales 
        group by InvoiceNo)as orders;
        
        

-- 10. Which customers have spent the most money?
   select CustomerID,max(Total_sales) as total_spent
   from sales
   group by CustomerID
   order by total_spent desc
   limit 10;


-- 12. When did each customer make their most recent purchase?
          select CustomerID, max(InvoiceDate) as most_recent_purchase
          from sales
          group by CustomerID;
          

-- 13. What is the average order value for each customer?
     select CustomerID,round(sum(Total_sales)/count(distinct InvoiceNo) ,2) as avg_order_value
     from sales
     group by CustomerID;


-- 14. What is the Recency of each customer?
select  CustomerID,datediff((select max(InvoiceDate) from sales),max(InvoiceDate)) as recency
from sales
group by CustomerID;

   
  --  15. What is the Frequency of each customer
     -- Frequency is usually the number of unique orders/purchases,?
     select CustomerID,count(distinct InvoiceNo) as frequency
     from sales
     group by CustomerID;

-- 16. What is the Monetary value of each customer?
     select CustomerID, round(sum(Total_sales) ,2) as Monetary
     from sales
     group by CustomerID
     order by Monetary desc
     ;




-- 17. How can Recency, Frequency, and Monetary values be combined into one RFM table?
       select CustomerID,
       datediff((select max(InvoiceDate) from sales),max(InvoiceDate)) as recency,

count(distinct InvoiceNo) as frequency,
round(sum(Total_sales) ,2) as Monetary
from sales
group by  CustomerID;
       

-- 18. How can customers be ranked based on their total spending?
   with customerspending as(
   select CustomerID,
   sum(Total_sales) as total_spent
   from sales
   group by CustomerID)
   select CustomerID,total_spent,
   rank() over(order by total_spent desc) as spending_rank
   from customerspending
   order by spending_rank;
   

-- 19. How can customers be divided into 5 groups using NTILE()?
     with customerspending as(
     select CustomerID,
   sum(Total_sales) as total_spent
   from sales
   group by CustomerID)
   select CustomerID,total_spent,
   ntile(5) over (order by total_spent desc ) as spendingGroup
   from customerspending;
 
-- 20. Who are the top 20% of customers based on revenue?
       with customerRevenue as(
       select CustomerID,sum(Total_sales) as revenue
       from sales
       group by CustomerID),
        customergroup as(
       select CustomerID,revenue,
       ntile(5) over(order by revenue desc) RevenueGroup
       from customerRevenue)
       select CustomerID,revenue
       from customergroup 
       where RevenueGroup =1
       order by revenue desc;
       


-- 22. Which customers have made more than 5 orders?
     select CustomerID,count(distinct InvoiceNo) as orders
     from sales
     group by CustomerID
     having count(distinct InvoiceNo) >5;

-- 23. Which customers have spent more than $1,000? #largest single transaction this customer made use Max() ,Which customers have spent more than $1,000 in total use sum()?"
select CustomerID ,sum(Total_sales) as totalSpent
from sales 
group by CustomerID
having sum(Total_sales) >1000
order by totalSpent desc;

CREATE TABLE rfm_score AS
SELECT 
    CustomerID,
    DATEDIFF((SELECT MAX(InvoiceDate) FROM sales), MAX(InvoiceDate)) AS recency,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    ROUND(SUM(Total_sales), 2) AS Monetary
FROM sales
GROUP BY CustomerID;
SHOW TABLES;
select * from rfm_score;
WITH scores AS (
    SELECT
        CustomerID,
        NTILE(5) OVER (ORDER BY Recency ASC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary DESC) AS M_Score
    FROM rfm_score
)
UPDATE rfm_score r
JOIN scores s
    ON r.CustomerID = s.CustomerID
SET
    r.R_Score = s.R_Score,
    r.F_Score = s.F_Score,
    r.M_Score = s.M_Score;
    UPDATE rfm_score
SET RFM_Score = CONCAT(R_Score, F_Score, M_Score);
SET SQL_SAFE_UPDATES = 1;
UPDATE rfm_score
SET Segment =
    CASE
        WHEN R_Score = 5 AND F_Score = 5 THEN 'High Value'
        WHEN R_Score >= 4 AND F_Score >= 4 THEN 'Loyal'
        WHEN R_Score >= 2 OR F_Score >= 2 THEN 'At-Risk'
        ELSE 'Dormant'
    END;
    SELECT * FROM rfm_score;
    ALTER TABLE rfm_score
ADD COLUMN FirstPurchaseDate DATETIME;
UPDATE rfm_score r
JOIN (
    SELECT
        CustomerID,
        MIN(InvoiceDate) AS FirstPurchaseDate
    FROM sales
    GROUP BY CustomerID
) s
ON r.CustomerID = s.CustomerID
SET r.FirstPurchaseDate = s.FirstPurchaseDate;
    SET SQL_SAFE_UPDATES = 0;
    SELECT *
FROM rfm_score;
ALTER TABLE rfm_score
DROP COLUMN RFM_Score;
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE rfm_score
ADD COLUMN f_Rank INT;
SET SQL_SAFE_UPDATES = 0;

WITH frequency_rank AS (
    SELECT
        CustomerID,
        RANK() OVER (ORDER BY Frequency DESC) AS F_Rank
    FROM rfm_score
)
UPDATE rfm_score r
JOIN frequency_rank f
    ON r.CustomerID = f.CustomerID
SET r.F_Rank = f.F_Rank;

SET SQL_SAFE_UPDATES = 1;
SELECT CustomerID, Frequency, F_Rank
FROM rfm_score
ORDER BY F_Rank;