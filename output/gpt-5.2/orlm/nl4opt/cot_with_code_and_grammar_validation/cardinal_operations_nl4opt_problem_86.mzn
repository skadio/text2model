% Parameters
int: customers_retail = 200;
int: employees_retail = 6;
int: customers_outlet = 80;
int: employees_outlet = 4;

int: min_customers = 1200;
int: max_employees = 50;

% Variables
var 0..(max_employees div employees_retail): n_retail;
var 0..(max_employees div employees_outlet): n_outlet;

var 0..(max_employees div min(employees_retail, employees_outlet)): total_stores;

% Constraints
constraint customers_retail * n_retail + customers_outlet * n_outlet >= min_customers;
constraint employees_retail * n_retail + employees_outlet * n_outlet <= max_employees;

constraint total_stores = n_retail + n_outlet;

% Objective
solve minimize total_stores;