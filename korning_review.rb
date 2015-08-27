require "pry"
require "csv"
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "korning-fall")
    yield(connection)
  ensure
    connection.close
  end
end

sales_data = CSV.readlines('sales.csv', headers: true)
db_connection do |conn|
sales_data.each do |row|


    product_match = conn.exec_params("SELECT * FROM products WHERE product_name = $1",
    [row["product_name"]])
    if product_match.count < 1
      conn.exec_params("INSERT INTO products (product_name) VALUES ($1)", [row["product_name"]])
    end

    frequency_match = conn.exec_params("SELECT * FROM frequency WHERE invoice_frequency = $1",
    [row["invoice_frequency"]])
    if frequency_match.count < 1
      conn.exec_params("INSERT INTO frequency (invoice_frequency) VALUES ($1)", [row["invoice_frequency"]])
    end

    employee_data = row["employee"].delete("()").split(" ")
    employee_match = conn.exec_params("SELECT * FROM employees WHERE email = ($1)", [employee_data[2]])
    if employee_match.count < 1
      conn.exec_params("INSERT INTO employees (name, last_name, email) VALUES ($1, $2, $3)", [employee_data[0], employee_data[1], employee_data[2]])
    end

    customer_data = row["customer_and_account_no"].delete("()").split(" ")
    acct_no_match = conn.exec_params("SELECT * FROM customers WHERE act_no = $1", [customer_data[1]])
    if acct_no_match.count < 1
      conn.exec_params("INSERT INTO customers (company_name, act_no) VALUES ($1, $2)", customer_data)
    end

    frequency_id = conn.exec_params("SELECT id FROM frequency WHERE invoice_frequency = $1",
    [row["invoice_frequency"]])
    frequency_id = frequency_id[0]["id"]

    product_id = conn.exec_params("SELECT id FROM products WHERE product_name = $1",
    [row["product_name"]])
    product_id = product_id[0]["id"]

    employee_id = conn.exec_params("SELECT id FROM employees WHERE email = $1",
    [row["employee"].delete("()").split(" ")[2]])
    employee_id = employee_id[0]["id"]

    customer_id = conn.exec_params("SELECT id FROM customers WHERE company_name = $1",
    [row["customer_and_account_no"].delete("()").split(" ")[0]])
    customer_id = customer_id[0]["id"]

    conn.exec_params("INSERT INTO sales
    (invoice_no,
    sale_date,
    sales_amount,
    units_sold,
    frequency_id,
    product_id,
    employee_id,
    customer_id)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
    [
      row["invoice_no"],
      row["sale_date"],
      row["sale_amount"],
      row["units_sold"],
      frequency_id,
      product_id,
      employee_id,
      product_id
      ])
  end
end
