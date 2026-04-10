% Minimize number of stores (retail + outlet) subject to customer and employee constraints.

int: customers_retail = 200;
int: employees_retail = 6;

int: customers_outlet = 80;
int: employees_outlet = 4;

int: min_customers = 1200;
int: max_employees = 50;

var 0..1000: retail_stores;
var 0..1000: outlet_stores;

constraint customers_retail * retail_stores + customers_outlet * outlet_stores >= min_customers;
constraint employees_retail * retail_stores + employees_outlet * outlet_stores <= max_employees;

solve minimize retail_stores + outlet_stores;

output [
  "retail_stores = ", show(retail_stores), "\n",
  "outlet_stores = ", show(outlet_stores), "\n",
  "total_stores = ", show(retail_stores + outlet_stores), "\n",
  "customers = ", show(customers_retail * retail_stores + customers_outlet * outlet_stores), "\n",
  "employees = ", show(employees_retail * retail_stores + employees_outlet * outlet_stores), "\n"
];