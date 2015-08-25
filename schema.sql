-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE if exists invoice, employee, customer, product, frequency;


CREATE TABLE employee (
  id serial PRIMARY KEY,
  emp_name varchar(100),
  emp_email varchar(100),
  UNIQUE (emp_name, emp_email)
);

CREATE TABLE customer (
  id serial PRIMARY KEY,
  cust_name varchar(100),
  cust_acct varchar(100),
  UNIQUE (cust_name, cust_acct)
);

CREATE TABLE product (
  id serial PRIMARY KEY,
  product_name varchar(100),
  UNIQUE (product_name)
);

CREATE TABLE frequency (
  id serial PRIMARY KEY,
  freq varchar(100),
  UNIQUE (freq)
);
CREATE TABLE invoice (
  id serial PRIMARY KEY,
  invoice_num integer,
  units integer,
  sales_date date,
  sales_amt decimal,
  freq_id integer REFERENCES frequency(id),
  emp_id integer REFERENCES employee(id),
  cust_id integer REFERENCES customer(id),
  product_id integer REFERENCES product(id)
);
