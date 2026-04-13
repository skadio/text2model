% Parameters
int: max_total_tours = 500;
int: min_diversity = 1000; % 3*X + 2*Y >= 1000
int: max_diff = 200;       % |X - Y| <= 200
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_total_tours: X;
var 0..max_total_tours: Y;
var 0..(cost_X*max_total_tours + cost_Y*max_total_tours): total_cost;

% Constraints
constraint X + Y <= max_total_tours;
constraint 3 * X + 2 * Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];