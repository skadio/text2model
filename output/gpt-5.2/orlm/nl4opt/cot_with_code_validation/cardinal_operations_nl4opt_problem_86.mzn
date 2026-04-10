% Parameters
int: customers_retail = 200;
int: employees_retail = 6;
int: customers_outlet = 80;
int: employees_outlet = 4;

int: min_customers = 1200;
int: max_employees = 50;

% Upper bounds from employee limits
int: max_retail = max_employees div employees_retail;
int: max_outlet = max_employees div employees_outlet;

% Variables
var 0..max_retail: n_retail;
var 0..max_outlet: n_outlet;

% Constraints
constraint
  customers_retail * n_retail + customers_outlet * n_outlet >= min_customers;

constraint
  employees_retail * n_retail + employees_outlet * n_outlet <= max_employees;

% Objective
solve minimize n_retail + n_outlet;