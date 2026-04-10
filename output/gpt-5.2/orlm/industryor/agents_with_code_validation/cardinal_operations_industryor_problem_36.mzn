% Parameters
% Processing time requirements (hours per unit)
int: time_I_A = 4;
int: time_I_B = 6;
int: time_II_A = 3;
int: time_II_B = 2;

% Weekly capacity (hours) for each process (regular time)
int: cap_I = 150;
int: cap_II = 70;

% Profit per unit ($)
int: profit_A = 300;
int: profit_B = 450;

% Goal/requirement parameters
int: min_profit = 10000;     % p1: minimum total weekly profit
int: min_A = 10;             % p2: minimum units of model A
int: min_B = 15;             % p2: minimum units of model B

% Conservative upper bounds for production variables (ensure feasibility with p3=exact utilization)
% Since Process I must be exactly 150 hours, we can bound each product by that capacity alone.
int: ub_A = cap_I div time_I_A;
int: ub_B = cap_I div time_I_B;

% Variables
var min_A..ub_A: units_A;     % number of model A produced per week
var min_B..ub_B: units_B;     % number of model B produced per week

var 0..(profit_A*ub_A + profit_B*ub_B): total_profit;  % total weekly profit ($)

% Process usage variables
var 0..cap_I: used_I;                                 % hours used in process I (p3 requires exactly cap_I)
var 0..cap_II: used_II;                               % regular hours used in process II (p3 requires exactly cap_II)
var 0..(time_II_A*ub_A + time_II_B*ub_B): overtime_II; % overtime hours in process II (if needed)

% Constraints
% --- Accounting: link production quantities to profit ---
constraint
  total_profit = profit_A * units_A + profit_B * units_B;

% --- Process I usage and full utilization requirement (p3) ---
constraint
  used_I = time_I_A * units_A + time_I_B * units_B;

constraint
  used_I = cap_I;

% --- Process II usage with full regular utilization and possible overtime (p3) ---
constraint
  time_II_A * units_A + time_II_B * units_B = used_II + overtime_II;

constraint
  used_II = cap_II;

% --- Minimum weekly profit requirement (p1) ---
constraint
  total_profit >= min_profit;

% --- Minimum production requirements (p2) ---
constraint units_A >= min_A;
constraint units_B >= min_B;

% Objective
solve maximize total_profit;