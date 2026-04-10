% Parameters
int: cost_fertilizer = 5;              % cost per unit of fertilizer ($/unit)
int: cost_seeds = 10;                  % cost per unit of seeds ($/unit)

int: total_units = 500;                % storage constraint: fertilizer + seeds = 500

int: coef_fert_ineq1 = 2;              % inequality 1: 2*fertilizer + 3*seeds <= 1000
int: coef_seeds_ineq1 = 3;
int: rhs_ineq1 = 1000;

int: coef_fert_ineq2 = 4;              % inequality 2: 4*fertilizer - seeds >= 200
int: coef_seeds_ineq2 = 1;
int: rhs_ineq2 = 200;

% Variables
var 0..total_units: fertilizer_units;  % whole units of fertilizer
var 0..total_units: seed_units;        % whole units of seeds

% Upper bound: maximum possible cost if all 500 units were seeds (more expensive)
var 0..(cost_fertilizer*total_units + cost_seeds*total_units): total_cost; % total cost in dollars

% Constraints
% Link total cost to chosen quantities
constraint
  total_cost = cost_fertilizer * fertilizer_units + cost_seeds * seed_units;

% Storage constraint: total units must equal the available capacity
constraint
  fertilizer_units + seed_units = total_units;

% Inequality 1: resource usage limit
constraint
  coef_fert_ineq1 * fertilizer_units + coef_seeds_ineq1 * seed_units <= rhs_ineq1;

% Inequality 2: minimum difference requirement
constraint
  coef_fert_ineq2 * fertilizer_units - coef_seeds_ineq2 * seed_units >= rhs_ineq2;

% Objective
solve minimize total_cost;