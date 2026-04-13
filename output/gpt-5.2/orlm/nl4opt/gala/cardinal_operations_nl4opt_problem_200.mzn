% Factory layout optimization (LP as integer decision: sq. feet allocated)
% All data embedded as requested.

int: total_space = 100;

% Per sq. foot
int: phone_labor = 2;
int: laptop_labor = 3;

int: phone_cost = 12;
int: laptop_cost = 15;

int: phone_revenue = 50;
int: laptop_revenue = 70;

int: max_budget = 5000;
int: max_labor = 2000;

% Decision variables: sq. feet allocated to each product
var 0..total_space: phone_space;
var 0..total_space: laptop_space;

% Resource constraints
constraint phone_space + laptop_space <= total_space;
constraint phone_cost * phone_space + laptop_cost * laptop_space <= max_budget;
constraint phone_labor * phone_space + laptop_labor * laptop_space <= max_labor;

% Objective: maximize revenue
var int: total_revenue = phone_revenue * phone_space + laptop_revenue * laptop_space;

solve maximize total_revenue;

output [
  "Phone_space_sqft = ", show(phone_space), "\n",
  "Laptop_space_sqft = ", show(laptop_space), "\n",
  "Unused_space_sqft = ", show(total_space - phone_space - laptop_space), "\n",
  "Total_cost = ", show(phone_cost * phone_space + laptop_cost * laptop_space), "\n",
  "Total_labor_hours = ", show(phone_labor * phone_space + laptop_labor * laptop_space), "\n",
  "Total_revenue = ", show(total_revenue), "\n"
];