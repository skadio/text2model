% Parameters
% Resource requirements per unit (hours)
float: asm_req_p1 = 1.0/4.0;   % assembly hours for product 1
float: test_req_p1 = 1.0/8.0;  % testing hours for product 1
float: asm_req_p2 = 1.0/3.0;   % assembly hours for product 2
float: test_req_p2 = 1.0/3.0;  % testing hours for product 2

% Material costs per unit ($)
float: mat_cost_p1 = 1.2;
float: mat_cost_p2 = 0.9;

% Sales values per unit ($)
float: value_p1 = 9.0;
float: value_p2 = 8.0;

% Capacities (hours)
float: asm_capacity = 90.0;     % regular assembly hours available
float: test_capacity = 80.0;    % testing hours available
float: asm_ot_max = 50.0;       % maximum overtime assembly hours

% Overtime cost ($/hour)
float: asm_ot_cost = 9.0;

% Variables
var int: x1;                 % number of product 1 units produced (integer, nonnegative)
var int: x2;                 % number of product 2 units produced (integer, nonnegative)
var float: asm_overtime;     % overtime assembly hours used (0..asm_ot_max)

% Profit variable (daily profit in dollars)
var float: profit;

% Constraints
%--- Nonnegativity and domain bounds ---
constraint x1 >= 0 /\ x2 >= 0;  % production quantities are nonnegative
constraint asm_overtime >= 0.0 /\ asm_overtime <= asm_ot_max;  % overtime bounds

%--- Assembly capacity with overtime ---
constraint
  asm_req_p1 * int2float(x1) + asm_req_p2 * int2float(x2)
  <= asm_capacity + asm_overtime;

%--- Testing capacity (no overtime available for testing) ---
constraint
  test_req_p1 * int2float(x1) + test_req_p2 * int2float(x2)
  <= test_capacity;

%--- Profit definition (revenue - material costs - overtime cost) ---
constraint
  profit =
    (value_p1 - mat_cost_p1) * int2float(x1)
  + (value_p2 - mat_cost_p2) * int2float(x2)
  - asm_ot_cost * asm_overtime;

% Objective
solve maximize profit;