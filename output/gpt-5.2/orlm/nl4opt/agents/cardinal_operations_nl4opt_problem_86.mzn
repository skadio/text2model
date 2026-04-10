% Parameters
int: customers_per_retail = 200;        % customers/day brought by one retail store
int: customers_per_outlet = 80;         % customers/day brought by one factory outlet
int: employees_per_retail = 6;          % employees needed for one retail store
int: employees_per_outlet = 4;          % employees needed for one factory outlet
int: min_customers = 1200;              % minimum total customers/day required
int: max_employees = 50;                % maximum employees available

% Upper bounds derived from resource limits (integer-safe)
int: max_retail_by_employees = max_employees div employees_per_retail;
int: max_outlet_by_employees = max_employees div employees_per_outlet;

% Variables
var 0..max_retail_by_employees: n_retail;   % number of retail stores to open
var 0..max_outlet_by_employees: n_outlet;   % number of factory outlets to open
var 0..(max_retail_by_employees + max_outlet_by_employees): n_stores; % total stores opened

% Constraints
% Customer demand constraint: ensure at least the minimum required customers/day
constraint
  customers_per_retail * n_retail + customers_per_outlet * n_outlet >= min_customers;

% Employee capacity constraint: do not exceed available employees
constraint
  employees_per_retail * n_retail + employees_per_outlet * n_outlet <= max_employees;

% Definition constraint: total number of stores equals sum of both store types
constraint
  n_stores = n_retail + n_outlet;

% Objective
solve minimize n_stores;