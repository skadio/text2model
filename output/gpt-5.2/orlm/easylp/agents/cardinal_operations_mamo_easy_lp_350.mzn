% Parameters
% Cost coefficients for each department allocation (X1..X4)
float: c1 = 0.5;
float: c2 = 0.2;
float: c3 = 0.3;
float: c4 = 0.4;

% Upper bounds on allocations
int: ub1 = 100;
int: ub2 = 80;
int: ub3 = 60;
int: ub4 = 50;

% Constraint right-hand sides
int: rhs_x1_x2_max = 100;    % X1 + X2 <= 100
int: rhs_x2_x3_min = 50;     % X2 + X3 >= 50
int: rhs_x3_x4_diff = 30;    % X3 - X4 <= 30
int: rhs_strategy_min = 150; % 10*X1 + 15*X2 - 5*X3 - 20*X4 >= 150


% Variables
% Integer allocations to each department (non-negative, bounded above)
var 0..ub1: X1;
var 0..ub2: X2;
var 0..ub3: X3;
var 0..ub4: X4;

% Total cost (float var for objective usage; bounded by maximum possible cost)
var 0.0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;


% Constraints
% --- Allocation sum constraints (budget/operational limits) ---
constraint X1 + X2 <= rhs_x1_x2_max;
constraint X2 + X3 >= rhs_x2_x3_min;

% --- Difference constraint between departments ---
constraint X3 - X4 <= rhs_x3_x4_diff;

% --- Strategic objective constraint (linear inequality) ---
constraint 10 * X1 + 15 * X2 - 5 * X3 - 20 * X4 >= rhs_strategy_min;

% --- Total cost definition ---
constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;


% Objective
solve minimize total_cost;