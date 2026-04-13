% Parameters
% Fatigue per training hour for each group
int: fatigue_x1 = 10;
int: fatigue_x2 = 15;
int: fatigue_x3 = 20;
int: fatigue_x4 = 25;

% Constraint limits and minimum requirements
int: max_x1_x2 = 12;   % x1 + x2 <= 12
int: max_x3_x4 = 16;   % x3 + x4 <= 16
int: min_x1_x3 = 8;    % x1 + x3 >= 8
int: min_x2_x4 = 10;   % x2 + x4 >= 10

% Upper bounds for decision variables (safe, derived from constraints)
int: ub_x1 = max_x1_x2;   % x1 cannot exceed x1+x2 limit
int: ub_x2 = max_x1_x2;   % x2 cannot exceed x1+x2 limit
int: ub_x3 = max_x3_x4;   % x3 cannot exceed x3+x4 limit
int: ub_x4 = max_x3_x4;   % x4 cannot exceed x3+x4 limit


% Variables
var 0..ub_x1: x1;  % weekly training hours for group X1 (integer, non-negative)
var 0..ub_x2: x2;  % weekly training hours for group X2 (integer, non-negative)
var 0..ub_x3: x3;  % weekly training hours for group X3 (integer, non-negative)
var 0..ub_x4: x4;  % weekly training hours for group X4 (integer, non-negative)

% total fatigue score (bounded by max possible within variable bounds)
var 0..(fatigue_x1*ub_x1 + fatigue_x2*ub_x2 + fatigue_x3*ub_x3 + fatigue_x4*ub_x4): total_fatigue;


% Constraints
% --- Facility availability limits (upper bounds on combined hours) ---
constraint x1 + x2 <= max_x1_x2;  % X1+X2 cannot exceed 12
constraint x3 + x4 <= max_x3_x4;  % X3+X4 cannot exceed 16

% --- Minimum training focus requirements (lower bounds on combined hours) ---
constraint x1 + x3 >= min_x1_x3;  % Ensure enough physical conditioning focus
constraint x2 + x4 >= min_x2_x4;  % Ensure enough skill/strategy focus

% --- Total fatigue definition ---
constraint total_fatigue =
  fatigue_x1 * x1 +
  fatigue_x2 * x2 +
  fatigue_x3 * x3 +
  fatigue_x4 * x4;


% Objective
solve minimize total_fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];