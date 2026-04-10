% Parameters
% Cost per worker for each project (embedded data)
int: cost_p1 = 1000;
int: cost_p2 = 2000;
int: cost_p3 = 3000;
int: cost_p4 = 4000;

% Maximum workers allowed on each project (embedded data)
int: max_p1 = 10;
int: max_p2 = 15;
int: max_p3 = 12;
int: max_p4 = 8;

% Constraint constants (embedded data)
int: max_p1_p2 = 20;     % P1 + P2 <= 20
int: min_p2_p3 = 10;     % P2 + P3 >= 10
int: max_diff_p3_p4 = 5; % |P3 - P4| <= 5
int: min_lin = 15;       % 2*P1 + 3*P2 - P4 >= 15


% Variables
% Number of workers assigned to each project (must be whole numbers)
var 0..max_p1: workers_p1;
var 0..max_p2: workers_p2;
var 0..max_p3: workers_p3;
var 0..max_p4: workers_p4;

% Total cost (integer dollars)
var int: total_cost;


% Constraints

% --- Project capacity bounds (redundant with variable domains, kept for clarity) ---
constraint
  workers_p1 <= max_p1 /\ workers_p2 <= max_p2 /\ workers_p3 <= max_p3 /\ workers_p4 <= max_p4;

% --- Budgetary/manpower coupling constraints between projects ---
constraint
  workers_p1 + workers_p2 <= max_p1_p2;     % P1 + P2 cannot exceed 20

constraint
  workers_p2 + workers_p3 >= min_p2_p3;     % P2 + P3 must be at least 10

% --- Project requirement: limit difference between P3 and P4 ---
constraint
  abs(workers_p3 - workers_p4) <= max_diff_p3_p4; % |P3 - P4| <= 5

% --- Additional linear requirement across projects ---
constraint
  2 * workers_p1 + 3 * workers_p2 - workers_p4 >= min_lin; % 2*P1 + 3*P2 - P4 >= 15

% --- Define total cost from allocations ---
constraint
  total_cost =
    cost_p1 * workers_p1 +
    cost_p2 * workers_p2 +
    cost_p3 * workers_p3 +
    cost_p4 * workers_p4;


% Objective
solve minimize total_cost;