% Unit costs (USD per unit resource) for each task
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

% Limits / requirements
int: limit_x1_x2 = 30;          % x1 + x2 <= 30
int: min_2x1_plus_x3 = 40;       % 2*x1 + x3 >= 40
int: diff_x4_minus_x2 = 20;      % x4 - x2 = 20
int: min_x1_plus_half_x3 = 10;   % x1 + 0.5*x3 >= 10  <=>  2*x1 + x3 >= 20

% Safe explicit upper bound (avoid undefined intmax)
int: UB = 1000;

% Decision variables (non-negative integers)
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Total cost
var 0..(cost_x1*UB + cost_x2*UB + cost_x3*UB + cost_x4*UB): total_cost;

% Constraints
constraint x1 + x2 <= limit_x1_x2;
constraint 2 * x1 + x3 >= min_2x1_plus_x3;
constraint x4 - x2 = diff_x4_minus_x2;
constraint 2 * x1 + x3 >= 2 * min_x1_plus_half_x3;

constraint total_cost =
  cost_x1 * x1 +
  cost_x2 * x2 +
  cost_x3 * x3 +
  cost_x4 * x4;

solve minimize total_cost;