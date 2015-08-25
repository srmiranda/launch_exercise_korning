# Use this file to import the sales information into the
# the database.
require "CSV"
require "pg"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end


paran_regex = /\(([^)]+)\)/ # captures email & cust_acct
name_regex = /^[^\(]+/ #captures emp name and cust name
trail_space_regex = /[ \t]+$/

CSV.foreach("sales.CSV", headers: true) do |row|
  emp_name = row[0].match(/^[^\(]+/)[0]
  emp_email = row[0].match(/\(([^)]+)\)/)[1]
  cust_name = row[1].match(/^[^\(]+/)[0]
  cust_acct = row[1].match(/\(([^)]+)\)/)[1]
  product = row[2]
  sale_date = row[3]
  sale_amt = row[4].match(/\d+\.\d+/)[0]
  unit_sold = row[5]
  inv_num = row[6]
  inv_freq = row[7]

  # table: frequency
  begin
  db_connection do |conn|
    conn.exec_params("INSERT INTO frequency (freq) VALUES ($1)", [inv_freq]);
  end
  rescue
    next
  end
end

CSV.foreach("sales.CSV", headers: true) do |row|
  emp_name = row[0].match(/^[^\(]+/)[0]
  emp_email = row[0].match(/\(([^)]+)\)/)[1]
  cust_name = row[1].match(/^[^\(]+/)[0]
  cust_acct = row[1].match(/\(([^)]+)\)/)[1]
  product = row[2]
  sale_date = row[3]
  sale_amt = row[4].match(/\d+\.\d+/)[0]
  unit_sold = row[5]
  inv_num = row[6]
  inv_freq = row[7]
  # table: product
  begin
  db_connection do |conn|
    conn.exec_params("INSERT INTO product (product_name) VALUES ($1)",
    [product]);
  end
  rescue
    next
  end
end

CSV.foreach("sales.CSV", headers: true) do |row|
  emp_name = row[0].match(/^[^\(]+/)[0]
  emp_email = row[0].match(/\(([^)]+)\)/)[1]
  cust_name = row[1].match(/^[^\(]+/)[0]
  cust_acct = row[1].match(/\(([^)]+)\)/)[1]
  product = row[2]
  sale_date = row[3]
  sale_amt = row[4].match(/\d+\.\d+/)[0]
  unit_sold = row[5]
  inv_num = row[6]
  inv_freq = row[7]
  # table: customer
  begin
  db_connection do |conn|
    conn.exec_params("INSERT INTO customer (cust_name, cust_acct) VALUES ($1, $2)",
    [cust_name, cust_acct]);
  end
  rescue
    next
  end
end

CSV.foreach("sales.CSV", headers: true) do |row|
  emp_name = row[0].match(/^[^\(]+/)[0]
  emp_email = row[0].match(/\(([^)]+)\)/)[1]
  cust_name = row[1].match(/^[^\(]+/)[0]
  cust_acct = row[1].match(/\(([^)]+)\)/)[1]
  product = row[2]
  sale_date = row[3]
  sale_amt = row[4].match(/\d+\.\d+/)[0]
  unit_sold = row[5]
  inv_num = row[6]
  inv_freq = row[7]
  # table: employee
  begin
  db_connection do |conn|
    conn.exec_params("INSERT INTO employee (emp_name, emp_email) VALUES ($1, $2)", [emp_name, emp_email]);
  end
  rescue
    next
  end
end

CSV.foreach("sales.CSV", headers: true) do |row|
  emp_name = row[0].match(/^[^\(]+/)[0]
  emp_email = row[0].match(/\(([^)]+)\)/)[1]
  cust_name = row[1].match(/^[^\(]+/)[0]
  cust_acct = row[1].match(/\(([^)]+)\)/)[1]
  product_name = row[2]
  sale_date = row[3]
  sale_amt = row[4].match(/\d+\.\d+/)[0]
  unit_sold = row[5]
  inv_num = row[6]
  inv_freq = row[7]
  # table: invoice
  begin
  db_connection do |conn|
    #frequency
    freq_type = conn.exec("SELECT freq FROM frequency Where freq = $1", [inv_freq])
    freq_covert = freq_type.to_a[0]["freq"]
    if freq_covert == inv_freq
       freq = conn.exec("SELECT id FROM frequency Where freq = $1", [inv_freq]).to_a[0]["id"];
    end

    #employer
    emp_type = conn.exec("SELECT emp_name FROM employee Where emp_name = $1", [emp_name])
    emp_covert = emp_type.to_a[0]["emp_name"]
    if emp_covert == emp_name
       emp = conn.exec("SELECT id FROM employee Where emp_name = $1", [emp_name]).to_a[0]["id"];
    end
    #
    # #customer
    cust_type = conn.exec("SELECT cust_name FROM customer Where cust_name = $1", [cust_name])
    cust_covert = cust_type.to_a[0]["cust_name"]
    if cust_covert == cust_name
       cust = conn.exec("SELECT id FROM customer Where cust_name = $1", [cust_name]).to_a[0]["id"];
    end
    #
    # #product id
    prod_type = conn.exec("SELECT product_name FROM product Where product_name = $1", [product_name])
    prod_covert = prod_type.to_a[0]["product_name"]
    if prod_covert == product_name
       prod = conn.exec("SELECT id FROM product Where product_name = $1", [product_name]).to_a[0]["id"];
    end

    conn.exec_params("INSERT INTO invoice (invoice_num, units, sales_date, sales_amt, freq_id, emp_id, cust_id, product_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
    [inv_num,
    unit_sold,
    sale_date,
    sale_amt,
    freq,
    emp,
    cust,
    prod]);
  end
  rescue
   next
 end
end
