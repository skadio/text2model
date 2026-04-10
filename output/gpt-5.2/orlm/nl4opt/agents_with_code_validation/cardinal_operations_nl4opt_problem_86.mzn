% Parameters
int: customers_per_retail = 200;         % customers/day brought by one retail store
int: customers_per_outlet = 80;          % customers/day brought by one factory outlet
int: employees_per_retail = 6;           % employees required per retail store
int: employees_per_outlet = 4;           % employees required per factory outlet
int: min_customers = 1200;               % minimum total customers/day required
int: max_employees = 50;                 % total employees available

% Useful bounds derived from parameters (safe upper bounds from employee availability)
int: max_retail = max_employees div employees_per_retail;
int: max_outlet = max_employees div employees_per_outlet;

% Variables
var 0..max_retail: num_retail_stores;                 % number of retail stores to open
var 0..max_outlet: num_outlet_stores;                 % number of factory outlets to open
var 0..(max_retail + max_outlet): total_stores;       % total stores opened (objective helper)

% Constraints

% --- Total stores definition ---
constraint total_stores = num_retail_stores + num_outlet_stores;

% --- Customer demand constraint ---
constraint
  customers_per_retail * num_retail_stores +
  customers_per_outlet * num_outlet_stores
  >= min_customers;

% --- Employee capacity constraint ---
constraint
  employees_per_retail * num_retail_stores +
  employees_per_outlet * num_outlet_stores
  <= max_employees;

% Objective
solve minimize total_stores;