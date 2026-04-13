% Parameters (with values embedded)
int: customers_retail = 200;
int: employees_retail = 6;
int: customers_outlet = 80;
int: employees_outlet = 4;

int: min_customers = 1200;
int: max_employees = 50;

% Variables
var 0..ceil(min_customers div customers_retail) + 100: retail_stores;
var 0..ceil(min_customers div customers_outlet) + 100: outlet_stores;

% Constraints
constraint customers_retail * retail_stores + customers_outlet * outlet_stores >= min_customers;
constraint employees_retail * retail_stores + employees_outlet * outlet_stores <= max_employees;

% Objective
solve minimize retail_stores + outlet_stores;