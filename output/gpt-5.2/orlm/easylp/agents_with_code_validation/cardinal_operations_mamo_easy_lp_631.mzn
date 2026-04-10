% Parameters
% Fatigue score per hour for each training group
int: fatigue_x1 = 2;
int: fatigue_x2 = 3;
int: fatigue_x3 = 4;
int: fatigue_x4 = 5;

% Constraint right-hand sides
int: max_x1_x2 = 100;            % x1 + x2 <= 100
int: min_x3_x4 = 50;             % x3 + x4 >= 50
int: eq_2x1_minus_x2 = 30;       % 2*x1 - x2 == 30
int: max_halfx4_minus_x3 = 20;   % (x4/2) - x3 <= 20

% Upper bounds for each group
int: ub_x1 = 60;
int: ub_x2 = 70;
int: ub_x3 = 80;
int: ub_x4 = 90;

% Lower bounds (non-negative hours)
int: lb = 0;

% Variables
var lb..ub_x1: x1; % hours in training group 1 (integer)
var lb..ub_x2: x2; % hours in training group 2 (integer)
var lb..ub_x3: x3; % hours in training group 3 (integer)
var lb..ub_x4: x4; % hours in training group 4 (integer)

% Total fatigue score (objective)
var 0..(fatigue_x1*ub_x1 + fatigue_x2*ub_x2 + fatigue_x3*ub_x3 + fatigue_x4*ub_x4): total_fatigue;


% Constraints

% --- Total fatigue score definition ---
constraint
  total_fatigue = fatigue_x1 * x1 + fatigue_x2 * x2 + fatigue_x3 * x3 + fatigue_x4 * x4;

% --- Training hours combination limits ---
% x1 + x2 cannot exceed 100
constraint
  x1 + x2 <= max_x1_x2;

% x3 + x4 must be at least 50
constraint
  x3 + x4 >= min_x3_x4;

% --- Exact relationship between x1 and x2 ---
% 2*x1 - x2 must equal 30
constraint
  2 * x1 - x2 = eq_2x1_minus_x2;

% --- Difference constraint involving half of x4 ---
% (x4/2) - x3 <= 20
% Avoid integer division issues by multiplying by 2: x4 - 2*x3 <= 40
constraint
  x4 - 2 * x3 <= 2 * max_halfx4_minus_x3;


% Objective
solve minimize total_fatigue;