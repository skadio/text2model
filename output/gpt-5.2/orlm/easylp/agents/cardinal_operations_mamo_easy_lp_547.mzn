% Parameters
% Operational cost per unit allocation in each sector
int: cost_manufacturing = 2;
int: cost_distribution  = 3;
int: cost_retail        = 4;

% Global capacity / budget limit
int: max_total_allocation = 1000;

% Constraint thresholds (scaled to avoid fractions)
% 5*x1 - 0.5*x2 >= 500  ==>  10*x1 - x2 >= 1000
int: min_prod_minus_half_dist_scaled = 1000;

% 4.5*x3 - x1 <= 450  ==>  9*x3 - 2*x1 <= 900
int: max_retail_balance_scaled = 900;

% x2 + 0.5*x3 - x1 >= 200  ==>  2*x2 + x3 - 2*x1 >= 400
int: min_logistics_condition_scaled = 400;

% Variable bounds from problem statement
int: ub_manufacturing = 599; % "less than 600"
int: ub_distribution  = 500; % "at most 500"
int: ub_retail        = 299; % "less than 300"

% Variables
var 0..ub_manufacturing: x1; % manufacturing allocation (integer units)
var 0..ub_distribution:  x2; % distribution allocation (integer units)
var 0..ub_retail:        x3; % retail allocation (integer units)

% Total cost (integer dollars/units)
var 0..(cost_manufacturing * ub_manufacturing
      + cost_distribution  * ub_distribution
      + cost_retail        * ub_retail): total_cost;

% Constraints

% --- Capacity / budget constraint: total allocation cannot exceed limit ---
constraint
  x1 + x2 + x3 <= max_total_allocation;

% --- Scaled linear constraint: 5*x1 - 0.5*x2 >= 500  (scaled by 2) ---
constraint
  10 * x1 - x2 >= min_prod_minus_half_dist_scaled;

% --- Scaled linear constraint: 4.5*x3 - x1 <= 450  (scaled by 2) ---
constraint
  9 * x3 - 2 * x1 <= max_retail_balance_scaled;

% --- Scaled linear constraint: x2 + 0.5*x3 - x1 >= 200  (scaled by 2) ---
constraint
  2 * x2 + x3 - 2 * x1 >= min_logistics_condition_scaled;

% --- Define total operational cost from allocations ---
constraint
  total_cost = cost_manufacturing * x1
             + cost_distribution  * x2
             + cost_retail        * x3;

% Objective
solve minimize total_cost;