% Renewable portfolio expansion: minimize investment cost
% Variables:
%   s = number of solar projects (integer)
%   w = number of wind projects (integer)

var 0..1000: s;
var 0..1000: w;

% Costs
int: cost_solar = 7;
int: cost_wind  = 5;

% Constraints
constraint 2*s + 3*w >= 10;   % balanced mix requirement
constraint 4*s + 1*w <= 15;   % grid/infrastructure limit

% Objective
var int: total_cost = cost_solar*s + cost_wind*w;
solve minimize total_cost;

output [
  "solar_projects = ", show(s), "\n",
  "wind_projects  = ", show(w), "\n",
  "min_total_cost = ", show(total_cost), "\n",
  "rounded_min_total_cost = ", show(total_cost), "\n"
];