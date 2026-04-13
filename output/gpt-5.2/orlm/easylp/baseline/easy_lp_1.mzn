% Budget allocation between two advertising channels X and Y (integer units).
% Minimize total cost subject to budget and effectiveness constraints.

int: max_budget = 2000;
int: costX = 50;
int: costY = 100;

% Decision variables: integer units of effectiveness purchased in each channel
var 0..(max_budget div costX): x;  % channel X units
var 0..(max_budget div costY): y;  % channel Y units

% Total spend cannot exceed budget
constraint costX * x + costY * y <= max_budget;

% Reach/frequency constraint: effort from X should be three times greater than twice Y,
% yielding a difference of at least 500 points: 3*x - 2*y >= 500
constraint 3 * x - 2 * y >= 500;

% Objective: minimize total cost
var 0..max_budget: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x=", show(x), " (units)\n",
  "y=", show(y), " (units)\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];