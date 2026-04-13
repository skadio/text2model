% Parameters
% Investment cost per building type (in dollars)
int: cost_house = 400000;
int: cost_apartment = 600000;

% Market demand constraint: 1.5*x + 2*y >= 500
float: demand_coef_house = 1.5;
float: demand_coef_apartment = 2.0;
float: demand_min = 500.0;

% Capacity constraint: 0.75*x + 1*y <= 300
float: capacity_coef_house = 0.75;
float: capacity_coef_apartment = 1.0;
float: capacity_max = 300.0;

% Derived safe upper bounds for decision variables (nonnegative integers)
% From capacity: 0.75*x <= 300 => x <= 400 ; and y <= 300 (when x = 0)
int: max_houses = 400;
int: max_apartments = 300;

% Variables
% Number of houses to build
var 0..max_houses: x;

% Number of apartments to build
var 0..max_apartments: y;

% Total investment (objective) in dollars
var 0..(cost_house * max_houses + cost_apartment * max_apartments): total_investment;

% Constraints
% Link total investment to decision variables
constraint
  total_investment = cost_house * x + cost_apartment * y;

% Market demand constraint: ensure sufficient combined value
constraint
  demand_coef_house * int2float(x) + demand_coef_apartment * int2float(y) >= demand_min;

% Construction capacity constraint: ensure workload does not exceed maximum
constraint
  capacity_coef_house * int2float(x) + capacity_coef_apartment * int2float(y) <= capacity_max;

% Objective
solve minimize total_investment;