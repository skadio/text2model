% Parameters
% Unit costs ($/unit) for each project type
int: cost_X1 = 150;
int: cost_X2 = 200;
int: cost_X3 = 300;
int: cost_X4 = 400;

% Maximum combined allocations due to resource limits
int: max_X1_X2 = 1000;
int: max_X3_X4 = 500;

% Minimum effectiveness requirements
int: min_eff_12 = 1200;  % 2*X1 + 3*X2 >= 1200
int: min_eff_34 = 2500;  % 5*X3 + 6*X4 >= 2500

% Effectiveness coefficients
int: eff12_X1 = 2;
int: eff12_X2 = 3;
int: eff34_X3 = 5;
int: eff34_X4 = 6;


% Variables
% Integer allocations (nonnegative) for each project type
var 0..max_X1_X2: X1;   % bounded by X1+X2 <= 1000
var 0..max_X1_X2: X2;   % bounded by X1+X2 <= 1000
var 0..max_X3_X4: X3;   % bounded by X3+X4 <= 500
var 0..max_X3_X4: X4;   % bounded by X3+X4 <= 500

% Total cost to minimize (safe upper bound based on variable bounds)
var 0..(cost_X1*max_X1_X2 + cost_X2*max_X1_X2 + cost_X3*max_X3_X4 + cost_X4*max_X3_X4): total_cost;


% Constraints
% --- Resource limit constraints (capacity on combined allocations) ---
constraint X1 + X2 <= max_X1_X2;
constraint X3 + X4 <= max_X3_X4;

% --- Effectiveness constraints (minimum required strategic scores) ---
constraint eff12_X1 * X1 + eff12_X2 * X2 >= min_eff_12;
constraint eff34_X3 * X3 + eff34_X4 * X4 >= min_eff_34;

% --- Total cost definition (link total_cost to allocations and unit costs) ---
constraint total_cost =
  cost_X1 * X1 +
  cost_X2 * X2 +
  cost_X3 * X3 +
  cost_X4 * X4;


% Objective
solve minimize total_cost;