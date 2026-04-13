% Parameters
% Cost per unit resource allocated to each department
int: cost_purchasing = 5;  % X
int: cost_sales      = 3;  % Y
int: cost_logistics  = 4;  % Z

% Capacity / coupling limits
int: max_X_plus_Y = 1000;  % X + Y <= 1000 (budget)
int: max_Y_plus_Z = 800;   % Y + Z <= 800 (manpower)

% Balance requirement
int: min_diff_X_Z = 200;   % |X - Z| >= 200 (at least 200 units difference)

% Upper bounds on allocations
int: max_X = 500;
int: max_Y = 300;
int: max_Z = 200;

% Variables
var 0..max_X: X;  % resources allocated to purchasing
var 0..max_Y: Y;  % resources allocated to sales
var 0..max_Z: Z;  % resources allocated to logistics

% Auxiliary variable for absolute difference
% Max possible |X-Z| is max_X (since X<=500 and Z>=0), so 0..max_X is safe.
var 0..max_X: absDiff_X_Z;

% Objective value (bounded by max possible total cost)
var 0..(cost_purchasing*max_X + cost_sales*max_Y + cost_logistics*max_Z): total_cost;

% Constraints

% --- Linking / definitions ---
constraint absDiff_X_Z = abs(X - Z);

constraint total_cost = cost_purchasing * X + cost_sales * Y + cost_logistics * Z;

% --- Coupling / capacity limits ---
constraint X + Y <= max_X_plus_Y;
constraint Y + Z <= max_Y_plus_Z;

% --- Balance requirement ---
constraint absDiff_X_Z >= min_diff_X_Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "absDiff_X_Z=", show(absDiff_X_Z), "\n",
  "total_cost=", show(total_cost), "\n"
];