% Parameters
% Promotion costs (units per allocation unit)
int: cost_x1 = 300;
int: cost_x2 = 200;
int: cost_x3 = 100;
int: cost_x4 = 50;

% Constraint RHS constants
int: max_x1_plus_x2 = 500;               % x1 + x2 <= 500
int: min_2x1_plus_3_5x3 = 700;           % 2*x1 + 3.5*x3 >= 700 (handled via scaling)
int: max_x2_minus_0_5x3_minus_x1 = 300;  % x2 - 0.5*x3 - x1 <= 300 (handled via scaling)
int: max_0_5x4_minus_x2 = 400;           % 0.5*x4 - x2 <= 400 (handled via scaling)
int: x4_le_x1_minus = 150;               % x4 <= x1 - 150

% Scaling factor to remove fractions (0.5 and 3.5)
int: scale = 2;

% Variables
% Resource allocations (whole numbers)
var 0..2000: x1;  % local culture
var 0..2000: x2;  % natural beauty
var 0..2000: x3;  % historical sites
var 0..2000: x4;  % adventure activities

% Total promotional cost to minimize
var 0..(300*2000 + 200*2000 + 100*2000 + 50*2000): total_cost;

% Constraints
% Link total cost to allocations (linear cost aggregation)
constraint
  total_cost =
    cost_x1 * x1 +
    cost_x2 * x2 +
    cost_x3 * x3 +
    cost_x4 * x4;

% Budget limitation: combined allocation for x1 and x2 cannot exceed limit
constraint
  x1 + x2 <= max_x1_plus_x2;

% Minimum visibility requirement:
% 2*x1 + 3.5*x3 >= 700  -> scale by 2: 4*x1 + 7*x3 >= 1400
constraint
  (2 * scale) * x1 + 7 * x3 >= scale * min_2x1_plus_3_5x3;

% Balanced promotions:
% x2 - 0.5*x3 - x1 <= 300 -> scale by 2: 2*x2 - x3 - 2*x1 <= 600
constraint
  scale * x2 - x3 - scale * x1 <= scale * max_x2_minus_0_5x3_minus_x1;

% Tourist preference balance:
% 0.5*x4 - x2 <= 400 -> scale by 2: x4 - 2*x2 <= 800
constraint
  x4 - scale * x2 <= scale * max_0_5x4_minus_x2;

% Operational policy: adventure activities no more than local culture minus 150
constraint
  x4 <= x1 - x4_le_x1_minus;

% Objective
solve minimize total_cost;