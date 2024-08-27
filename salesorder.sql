CREATE TABLE SalesOrders (
    Row_ID INT PRIMARY KEY,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country_Region VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(150),
    Sales DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(5, 2),
    Profit DECIMAL(10, 2)
);
COPY SalesOrders(Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country_Region, City, State, Postal_Code, Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit)
FROM 'C:\Users\kiran\OneDrive\Desktop\data analyst\SQL\merge-csv.com__66c9dc5047224.csv' 
DELIMITER ',' 
CSV HEADER
ENCODING 'WIN1252';

---total Revenue Generated Each Year
SELECT 
    EXTRACT(YEAR FROM order_date) AS year, 
    SUM(sales) AS total_revenue
FROM salesorders
GROUP BY year
ORDER BY year;

--Top Product Categories and Sub-Categories by Revenue
SELECT 
    product_category, 
    product_sub_category, 
    SUM(sales) AS total_revenue
FROM salesorders
GROUP BY product_category, product_sub_category
ORDER BY total_revenue DESC
LIMIT 10;
--Top Customers by Revenue
SELECT 
    customer_name, 
    customer_segment, 
    SUM(sales) AS total_revenue
FROM salesorders
GROUP BY customer_name, customer_segment
ORDER BY total_revenue DESC
LIMIT 10;

--Highest Profit Margins by Product 
SELECT 
    product_name, 
    (SUM(profit) / SUM(sales)) * 100 AS profit_margin_percentage
FROM salesorders
GROUP BY product_name
ORDER BY profit_margin_percentage DESC
LIMIT 10;

--Sales Performance by Region
SELECT 
    region, 
    SUM(sales) AS total_revenue, 
    SUM(profit) AS total_profit
FROM salesorders
GROUP BY region
ORDER BY total_revenue DESC;

--Sales Performance by Month/Quarter
SELECT 
    EXTRACT(MONTH FROM order_date) AS month, 
    SUM(sales) AS total_sales
FROM salesorders
GROUP BY month
ORDER BY month;

--Customer Repeat Purchases
SELECT 
    customer_name, 
    COUNT(order_id) AS number_of_purchases, 
    AVG(order_date - LAG(order_date) OVER (PARTITION BY customer_name ORDER BY order_date)) AS avg_time_between_purchases
FROM salesorders
GROUP BY customer_name
HAVING COUNT(order_id) > 1
ORDER BY number_of_purchases DESC;

--Inventory Management (Stock-Out or Excess Inventory)

SELECT 
    product_name, 
    SUM(quantity) AS total_quantity_sold
FROM salesorders
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;




