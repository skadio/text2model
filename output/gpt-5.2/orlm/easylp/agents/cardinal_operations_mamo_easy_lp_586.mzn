% Parameters
% Unit costs ($ per unit investment) for projects X1..X4
array[1..4] of int: cost = [50, 60, 70, 80];

% Budget/limit constraints
int: max_x1_x2 = 500;     % X1 + X2 <= 500
int: max_x3_x4 = 600;     % X3 + X4 <= 600

% Difference constraints
int: min_diff_x3_vs_x1x2 = 100;  % X3 - (X1 + X2) >= 100
int: min_x4_over_x2 = 50;        % X4 - X2 >= 50


% Variables
var 0..max_x1_x2: x1;  % investment in project X1
var 0..max_x1_x2: x2;  % investment in project X2
var 0..max_x3_x4: x3;  % investment in project X3
var 0..max_x3_x4: x4;  % investment in project X4

% Total cost (bounded using the above variable upper bounds)
var 0..(max_x1_x2*cost[1] + max_x1_x2*cost[2] + max_x3_x4*cost[3] + max_x3_x4*cost[4]): total_cost;


% Constraints
% --- Budget/limit constraints (project group caps) ---
constraint x1 + x2 <= max_x1_x2;  % X1 + X2 cannot exceed 500 units
constraint x3 + x4 <= max_x3_x4;  % X3 + X4 cannot exceed 600 units

% --- Difference/relationship constraints (policy/strategy requirements) ---
constraint x3 - (x1 + x2) >= min_diff_x3_vs_x1x2;  % X3 at least 100 more than (X1+X2)
constraint x4 - x2 >= min_x4_over_x2;              % X4 at least 50 more than X2

% --- Total cost definition (link decision variables to total_cost) ---
constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;


% Objective
solve minimize total_cost;