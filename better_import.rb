# Use this file to import the sales information into the
# the database.

require "pg"
require "csv"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
	    yield(connection)
	  ensure
	    connection.close
	  end
	end

	CSV.foreach("sales.csv", headers: true, header_converters: :symbol) do |row|
	  # process all info from csv file
	  row = row.to_hash
	  employee_info = row[:employee].split('(')
	  employee_name = employee_info[0]
	  employee_name = employee_name.chomp(' ')
	  employee_email = employee_info[1].chomp(')')

	  customer_info = row[:customer_and_account_no].split('(')
	  customer_name = customer_info[0]
	  customer_name = customer_name.chomp(' ')
	  customer_account_number = customer_info[1].chomp(')')

  db_connection do |conn|
	    # Check if employee exists already
	    employee_exists = conn.exec("SELECT COUNT(*) FROM employee_info WHERE employee_name = '#{employee_name}'")
	    # Add employee to employee table if not there already
	    if employee_exists[0]['count'] == '0'
	      conn.exec_params("INSERT INTO employee_info (employee_name, employee_email) VALUES ($1,$2)", [employee_name, employee_email])
	    end

	    # Check if customer exists already
	    customer_exists = conn.exec("SELECT COUNT(*) FROM customer_info WHERE customer_account_number_primary = '#{customer_account_number}'")
	    # Add customer to customer table if not there already
	    if customer_exists[0]['count'] == '0'
	      conn.exec_params("INSERT INTO customer_info (customer_name, customer_account_number_primary) VALUES ($1,$2)", [customer_name, customer_account_number])
	    end

	    # Check if purchase exists already
	    purchase_exists = conn.exec("SELECT COUNT(*) FROM purchases WHERE invoice_number = '#{row[:invoice_no]}'")
	    if purchase_exists[0]['count'] == '0'
	    # Add to purchases table
	      employee_id = conn.exec("SELECT employee_id_primary FROM employee_info WHERE employee_name = '#{employee_name}'")
	      employee_id = employee_id[0]['employee_id_primary']
	      conn.exec_params("INSERT INTO purchases (employee_id_foreign, customer_account_number_foreign, product_name, sale_date, sale_amount, units_sold, invoice_number, invoice_frequency)
	      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
	      [employee_id, customer_account_number, row[:product_name], row[:sale_date], row[:sale_amount], row[:units_sold], row[:invoice_no], row[:invoice_frequency]])
	    end

	  end
	end
