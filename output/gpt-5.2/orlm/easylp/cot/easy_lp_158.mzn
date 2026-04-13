% Parameters (with values embedded)
int: cost_house = 400000;
int: cost_apartment = 600000;

int: demand_min = 500;          % 1.5*x + 2*y >= 500
int: capacity_max = 300;        % 0.75*x + 1*y <= 300

% Variables
var 0..10000: x;  % number of houses
var 0..10000: y;  % number of apartments
var 0..10000000000: total_investment;

% Constraints
% Eliminate fractions by multiplying:
% 1.5*x + 2*y >= 500  -> 3*x + 4*y >= 1000
constraint 3*x + 4*y >= 2 * demand_min;

% 0.75*x + y <= 300   -> 3*x + 4*y <= 1200
constraint 3*x + 4*y <= 4 * capacity_max;

constraint total_investment = cost_house * x + cost_apartment * y;

% Objective
solve minimize total_investment;

output [
  "x (houses) = ", show(x), "\n",
  "y (apartments) = ", show(y), "\n",
  "total_investment = $", show(total_investment), "\n"
];