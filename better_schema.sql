-- DEFINE YOUR DATABASE SCHEMA HERE

DROP TABLE if exists employee_info, customer_info, purchases;


	CREATE TABLE employee_info (
	  employee_id_primary SERIAL,
	  employee_name varchar(100),
	  employee_email varchar(100)
	);

	CREATE TABLE customer_info (
	  customer_name varchar(100),
	  customer_account_number_primary varchar(20)
	);

	CREATE TABLE purchases (
	  employee_id_foreign integer,
	  customer_account_number_foreign varchar(20),
	  product_name varchar(100),
	  sale_date date,
	  sale_amount money,
	  units_sold integer,
	  invoice_number integer,
	  invoice_frequency varchar(50)
	);
