% Parameters
% Unit costs (in dollars per unit)
int: fertilizer_cost = 5;
int: seed_cost = 10;

% Total units to allocate due to storage constraints
int: total_units = 500;

% Constraint coefficients/thresholds
int: max_weighted_sum = 1000;      % upper bound for 2*fertilizer + 3*seeds
int: min_weighted_diff = 200;      % lower bound for 4*fertilizer - seeds


% Variables
% Allocation decisions (whole number of units)
var 0..total_units: fertilizer_units;  % fertilizer units allocated
var 0..total_units: seed_units;        % seed units allocated

% Total cost (bounded for linear expressions)
var 0..(fertilizer_cost*total_units + seed_cost*total_units): total_cost;  % objective value


% Constraints
%-------------------------------
% Total units (storage constraint)
%-------------------------------
constraint fertilizer_units + seed_units = total_units;

%--------------------------------------------
% Weighted sum limit: 2*fertilizer + 3*seeds
%--------------------------------------------
constraint 2 * fertilizer_units + 3 * seed_units <= max_weighted_sum;

%-----------------------------------------------------
% Weighted difference minimum: 4*fertilizer - 1*seeds
%-----------------------------------------------------
constraint 4 * fertilizer_units - seed_units >= min_weighted_diff;

%------------------------------------
% Define total cost from allocations
%------------------------------------
constraint total_cost = fertilizer_cost * fertilizer_units + seed_cost * seed_units;


% Objective
solve minimize total_cost;

% (Optional) output for inspection
output [
  "fertilizer_units=", show(fertilizer_units), "\n",
  "seed_units=", show(seed_units), "\n",
  "total_cost=", show(total_cost), "\n"
];