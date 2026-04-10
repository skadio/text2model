% Factory layout optimization (all data embedded)

int: total_space = 100;              % sq. feet available
int: max_budget = 5000;              % dollars
int: max_labor_hours = 2000;         % hours

% Per sq. foot requirements/costs/revenues
int: phone_labor = 2;
int: laptop_labor = 3;

int: phone_cost = 12;
int: laptop_cost = 15;

int: phone_revenue = 50;
int: laptop_revenue = 70;

% Decision variables: sq. feet allocated (assume integer sq. feet)
var 0..total_space: phone_space;
var 0..total_space: laptop_space;

constraint phone_space + laptop_space <= total_space;

constraint phone_cost * phone_space + laptop_cost * laptop_space <= max_budget;

constraint phone_labor * phone_space + laptop_labor * laptop_space <= max_labor_hours;

var int: total_revenue = phone_revenue * phone_space + laptop_revenue * laptop_space;

solve maximize total_revenue;

output [
  "Phone space (sq ft): ", show(phone_space), "\n",
  "Laptop space (sq ft): ", show(laptop_space), "\n",
  "Total space used (sq ft): ", show(phone_space + laptop_space), "\n",
  "Total cost ($): ", show(phone_cost * phone_space + laptop_cost * laptop_space), "\n",
  "Total labor (hours): ", show(phone_labor * phone_space + laptop_labor * laptop_space), "\n",
  "Total revenue ($): ", show(total_revenue), "\n"
];