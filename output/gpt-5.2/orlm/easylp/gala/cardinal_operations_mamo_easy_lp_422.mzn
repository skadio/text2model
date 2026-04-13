include "globals.mzn";

% Data (embedded from the description)
int: cost_raw = 5;      % $ per unit raw materials
int: cost_labor = 10;   % $ per unit labor

% Decision variables (whole numbers)
var 0..100: raw;        % units of raw materials
var 0..100: labor;      % units of labor allocation

% Constraints
constraint 2 * raw + 3 * labor >= 20;
constraint abs(raw - labor) <= 30;
constraint raw + labor = 100;

% Objective: minimize total cost in dollars
var int: total_cost = cost_raw * raw + cost_labor * labor;

solve minimize total_cost;

output [
  "raw = ", show(raw), "\n",
  "labor = ", show(labor), "\n",
  "total_cost = ", show(total_cost), "\n"
];