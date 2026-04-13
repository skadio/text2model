% Parameters
% Cost per worker on each project (USD)
int: cost_P1 = 1000;
int: cost_P2 = 2000;
int: cost_P3 = 3000;
int: cost_P4 = 4000;

% Maximum workers allowed on each project
int: max_P1 = 10;
int: max_P2 = 15;
int: max_P3 = 12;
int: max_P4 = 8;

% Constraint constants
int: max_P1P2 = 20;      % P1 + P2 <= 20
int: min_P2P3 = 10;      % P2 + P3 >= 10
int: max_diff_P3P4 = 5;  % |P3 - P4| <= 5
int: min_expr = 15;      % 2*P1 + 3*P2 - P4 >= 15


% Variables
% Number of workers assigned to each project (whole numbers within bounds)
var 0..max_P1: w_P1;
var 0..max_P2: w_P2;
var 0..max_P3: w_P3;
var 0..max_P4: w_P4;

% Total cost (USD), bounded by max possible spend
var 0..(max_P1*cost_P1 + max_P2*cost_P2 + max_P3*cost_P3 + max_P4*cost_P4): total_cost;


% Constraints
% --- Workforce coupling constraints between projects ---
constraint w_P1 + w_P2 <= max_P1P2;           % Combined workers on P1 and P2 cannot exceed limit
constraint w_P2 + w_P3 >= min_P2P3;           % Combined workers on P2 and P3 must be at least minimum

% --- Balance constraint between P3 and P4 ---
constraint abs(w_P3 - w_P4) <= max_diff_P3P4; % Difference between P3 and P4 workers bounded

% --- Minimum workforce expression constraint ---
constraint 2*w_P1 + 3*w_P2 - w_P4 >= min_expr; % Required linear combination lower bound

% --- Total cost definition ---
constraint total_cost =
  cost_P1*w_P1 + cost_P2*w_P2 + cost_P3*w_P3 + cost_P4*w_P4;


% Objective
solve minimize total_cost;

output [
  "w_P1=", show(w_P1), "\n",
  "w_P2=", show(w_P2), "\n",
  "w_P3=", show(w_P3), "\n",
  "w_P4=", show(w_P4), "\n",
  "total_cost=", show(total_cost), "\n"
];