# MegaMart Sales Analysis (SQL + Power BI)

## Project Overview
This project analyzes sales data from a fictional e-commerce platform called **MegaMart**.  
The goal was to extract meaningful business insights from raw transactional data using **SQL** and visualize the results through an interactive **Power BI dashboard**.

The project focuses on understanding:
- Sales performance
- Customer behavior
- Product demand
- Revenue distribution
- Customer retention

---

## Tools & Technologies Used

- SQL (MySQL)
- Power BI
- Data Modeling
- Data Visualization
- Window Functions
- CTEs (Common Table Expressions)

---

## Database Tables Used

The analysis was performed using the following tables:

- `customers`
- `orders`
- `order_items`
- `products`

Additional analytical views used:
- `vw_customer_clv`
- `vw_rfm`

---

## Key Business Questions Answered

### Sales Analysis
- What are the monthly revenue trends?
- Which months generated the highest revenue?
- Which cities drive the most revenue?

### Customer Analysis
- Who are the top customers by spending?
- How many customers make repeat purchases?
- Which customers are at risk of churn?
- How are customers segmented using **RFM analysis**?

### Product Analysis
- Which products sell the most units?
- Which categories generate the highest revenue?
- Which products have low sales performance?

### Operational Insights
- Which payment methods contribute most to revenue?
- What is the distribution of order statuses (completed, cancelled, returned)?
- Which cities have the highest average order value?

---

## SQL Analysis Performed

The project includes the following analysis tasks:

1. Data quality checks
2. Monthly sales performance
3. Top revenue generating cities
4. Payment method contribution
5. Order status funnel analysis
6. Repeat purchase behaviour
7. Cohort retention analysis
8. High revenue months identification
9. Customer lifetime value analysis
10. Top 100 customers by revenue
11. RFM customer segmentation
12. High churn risk customers
13. City level customer insights
14. Top selling products
15. Category profitability analysis
16. Low performing products identification

---

## Dashboard Overview

An interactive dashboard was created in **Power BI** with two pages:

### 1. Sales Overview
Displays key business metrics including:
- Total Revenue
- Total Orders
- Total Customers
- Units Sold
- Repeat Customers
- Average Order Value

Additional visuals:
- Revenue trend by year
- Revenue by state
- Sales filters

### 2. Customer & Product Insights
Displays deeper analytical insights including:
- Top selling products
- Category revenue contribution
- Top customers by spending
- Payment method distribution
- Order status analysis

---

## Key Business Insight

Although the platform generated **124M in total revenue**, only **31M comes from completed orders**.  
This indicates a significant opportunity to improve operational efficiency and increase order completion rates.

---

## Project Structure
MegaMart-Sales-Analysis
│
├── megamart_sales_analysis.sql
├── README.md
└── dashboard_images
├── sales_overview.png
└── customer_product_insights.png



---

## Skills Demonstrated

- SQL Query Writing
- Data Aggregation & Filtering
- Window Functions
- CTEs
- Customer Segmentation
- Business Data Analysis
- Dashboard Development
- Data Storytelling

---

## Future Improvements

Possible enhancements for this project include:

- Profit analysis
- Customer lifetime value forecasting
- Product recommendation analysis
- Time series sales forecasting

---

## Author

**Towheed Qayoom**

Aspiring Data Analyst focused on SQL, Power BI, and data-driven insights.
