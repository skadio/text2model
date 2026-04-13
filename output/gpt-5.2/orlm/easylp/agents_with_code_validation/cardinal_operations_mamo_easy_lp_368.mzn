% Parameters
int: cost_X1 = 500;          % Cost per unit for project X1
int: cost_X2 = 300;          % Cost per unit for project X2
int: cost_X3 = 700;          % Cost per unit for project X3
int: cost_X4 = 600;          % Cost per unit for project X4

int: max_X1 = 50;            % Maximum units allocable to X1
int: max_X2 = 60;            % Maximum units allocable to X2
int: max_X3 = 40;            % Maximum units allocable to X3
int: max_X4 = 30;            % Maximum units allocable to X4

int: cap_X1_X2 = 100;        % Upper bound for X1 + X2
int: cap_2X3_X4 = 120;       % Upper bound for 2*X3 + X4
int: min_X1_X3 = 60;         % Lower bound for X1 + X3
int: min_X2_X4 = 80;         % Lower bound for X2 + X4


% Variables
var 0..max_X1: X1;           % Integer allocation (units) to project X1
var 0..max_X2: X2;           % Integer allocation (units) to project X2
var 0..max_X3: X3;           % Integer allocation (units) to project X3
var 0..max_X4: X4;           % Integer allocation (units) to project X4

var int: total_cost;         % Total cost (objective), in dollars


% Constraints
% --- Budget/capacity upper-bound constraints ---
constraint X1 + X2 <= cap_X1_X2;
constraint 2 * X3 + X4 <= cap_2X3_X4;

% --- Minimum requirement constraints ---
constraint X1 + X3 >= min_X1_X3;
constraint X2 + X4 >= min_X2_X4;

% --- Total cost definition ---
constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;


% Objective
solve minimize total_cost;

% (Optional) Output for convenience
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];