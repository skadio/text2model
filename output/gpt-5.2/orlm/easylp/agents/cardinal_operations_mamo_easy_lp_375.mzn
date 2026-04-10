% Parameters
int: cost_x1 = 50;               % Cost per employee in department x1
int: cost_x2 = 70;               % Cost per employee in department x2
int: cost_x3 = 90;               % Cost per employee in department x3
int: cost_x4 = 110;              % Cost per employee in department x4

int: max_x1 = 20;                % Upper bound on employees in x1
int: max_x2 = 15;                % Upper bound on employees in x2
int: max_x3 = 10;                % Upper bound on employees in x3
int: max_x4 = 5;                 % Upper bound on employees in x4

int: cap_x1_x2 = 40;             % Capacity constraint: x1 + x2 <= 40
int: cap_x2_x3 = 30;             % Capacity constraint: x2 + x3 <= 30
int: cap_x3_x4 = 20;             % Capacity constraint: x3 + x4 <= 20

int: extra_x1_over_half_x4 = 10; % Constraint offset in: x1 >= (x4/2) + 10


% Variables
var 0..max_x1: x1;               % Employees allocated to department x1
var 0..max_x2: x2;               % Employees allocated to department x2
var 0..max_x3: x3;               % Employees allocated to department x3
var 0..max_x4: x4;               % Employees allocated to department x4

var int: total_cost;             % Total hiring cost (minimize)


% Constraints
% --- Capacity constraints between department pairs ---
constraint x1 + x2 <= cap_x1_x2;
constraint x2 + x3 <= cap_x2_x3;
constraint x3 + x4 <= cap_x3_x4;

% --- Team size relationship constraint ---
% Enforce integer version of: x1 >= floor(x4/2) + extra_x1_over_half_x4
% Avoid fractional arithmetic: 2*x1 >= x4 + 2*extra
constraint 2 * x1 >= x4 + 2 * extra_x1_over_half_x4;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;