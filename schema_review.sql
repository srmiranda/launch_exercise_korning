DROP TABLE IF EXISTS employees, customers, products, frequency, sales;

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name varchar(100),
  last_name varchar(100),
  email varchar(100)
);
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  company_name varchar(100),
  act_no varchar(100)
);
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  product_name varchar(100)
);
CREATE TABLE frequency (
  id SERIAL PRIMARY KEY,
  invoice_frequency varchar(100)
);
CREATE TABLE sales(
  id SERIAL PRIMARY KEY,
  units_sold int,
  invoice_no int,
  sale_date DATE,
  sales_amount MONEY,
  employee_id integer references employees(id),
  customer_id integer references customers(id),
  product_id integer references products(id),
  frequency_id integer references frequency(id)
);
