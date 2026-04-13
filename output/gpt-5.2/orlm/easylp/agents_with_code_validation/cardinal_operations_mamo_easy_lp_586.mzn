% Parameters
% Unit costs for each project investment
int: cost_X1 = 50;
int: cost_X2 = 60;
int: cost_X3 = 70;
int: cost_X4 = 80;

% Budget limits
int: max_X1_X2 = 500;   % X1 + X2 <= 500
int: max_X3_X4 = 600;   % X3 + X4 <= 600

% Difference requirements
int: min_diff_X3_vs_X1X2 = 100;  % X3 - (X1 + X2) >= 100
int: min_diff_X4_vs_X2   = 50;   % X4 - X2 >= 50

% Simple upper bounds derived from the budget constraints (for tighter variable domains)
int: ub_X1 = max_X1_X2;
int: ub_X2 = max_X1_X2;
int: ub_X3 = max_X3_X4;
int: ub_X4 = max_X3_X4;

% Variables
% Investment amounts (whole units)
var 0..ub_X1: X1;
var 0..ub_X2: X2;
var 0..ub_X3: X3;
var 0..ub_X4: X4;

% Total cost (in dollars)
var 0..(cost_X1*ub_X1 + cost_X2*ub_X2 + cost_X3*ub_X3 + cost_X4*ub_X4): total_cost;

% Constraints
% --- Budget constraints ---
constraint X1 + X2 <= max_X1_X2;  % Total investment in projects X1 and X2 limited
constraint X3 + X4 <= max_X3_X4;  % Total investment in projects X3 and X4 limited

% --- Difference / policy constraints ---
constraint X3 - (X1 + X2) >= min_diff_X3_vs_X1X2;  % X3 at least 100 more than (X1 + X2)
constraint X4 - X2 >= min_diff_X4_vs_X2;           % X4 at least 50 more than X2

% --- Total cost definition ---
constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% Objective
solve minimize total_cost;

% Optional: display decision variables and objective
output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];