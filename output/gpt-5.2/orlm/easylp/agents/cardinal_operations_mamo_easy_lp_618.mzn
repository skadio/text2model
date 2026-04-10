% Parameters
% Fatigue score per hour for each team
int: fatigue_x1 = 2;
int: fatigue_x2 = 3;
int: fatigue_x3 = 4;
int: fatigue_x4 = 5;

% Constraint constants
int: max_x1_x2 = 8;          % x1 + x2 <= 8
int: min_2x2_x3 = 10;        % 2*x2 + x3 >= 10
int: max_x3_3x4 = 15;        % x3 - 3*x4 <= 15
int: diff_x4_x1 = 5;         % x4 - x1 == 5


% Variables
% Integer work hours assigned to each team (non-negative)
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Total fatigue to minimize
var int: total_fatigue;


% Constraints
% Non-negativity (whole hours, no negative allocations)
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% Define objective expression
constraint total_fatigue = fatigue_x1*x1 + fatigue_x2*x2 + fatigue_x3*x3 + fatigue_x4*x4;

% --- Team-hours availability: x1 + x2 <= 8 ---
constraint x1 + x2 <= max_x1_x2;

% --- Project demand: 2*x2 + x3 >= 10 ---
constraint 2 * x2 + x3 >= min_2x2_x3;

% --- Workload balance: x3 - 3*x4 <= 15 ---
constraint x3 - 3 * x4 <= max_x3_3x4;

% --- Coordination requirement: x4 - x1 == 5 ---
constraint x4 - x1 = diff_x4_x1;


% Objective
solve minimize total_fatigue;