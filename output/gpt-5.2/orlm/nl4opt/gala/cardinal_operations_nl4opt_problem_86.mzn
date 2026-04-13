% Clothing company store distribution optimization
% Minimize the number of stores subject to customer demand and employee availability.

int: cust_retail = 200;
int: emp_retail  = 6;

int: cust_outlet = 80;
int: emp_outlet  = 4;

int: min_customers = 1200;
int: max_employees = 50;

% Decision variables: number of each store type to open
var 0..max_employees div emp_retail: retail;
var 0..max_employees div emp_outlet: outlet;

% Constraints
constraint cust_retail * retail + cust_outlet * outlet >= min_customers;
constraint emp_retail  * retail + emp_outlet  * outlet <= max_employees;

% Objective: minimize total number of stores
var 0..(max_employees div emp_retail + max_employees div emp_outlet): total_stores
  = retail + outlet;

solve minimize total_stores;

output [
  "Retail stores  = ", show(retail), "\n",
  "Outlet stores  = ", show(outlet), "\n",
  "Total stores   = ", show(total_stores), "\n",
  "Customers/day  = ", show(cust_retail * retail + cust_outlet * outlet), "\n",
  "Employees used = ", show(emp_retail * retail + emp_outlet * outlet), "\n"
];