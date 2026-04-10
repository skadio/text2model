% Parameters
% Fatigue score per hour for each group
int: fatigue_x1 = 10;
int: fatigue_x2 = 15;
int: fatigue_x3 = 20;
int: fatigue_x4 = 25;

% Capacity / availability limits
int: max_x1_x2 = 12;   % x1 + x2 <= 12
int: max_x3_x4 = 16;   % x3 + x4 <= 16

% Minimum focus requirements
int: min_x1_x3 = 8;    % x1 + x3 >= 8
int: min_x2_x4 = 10;   % x2 + x4 >= 10

% Variable upper bounds (derived from constraints to keep variables bounded)
int: UB_x1 = max_x1_x2;  % x1 <= x1 + x2 <= 12
int: UB_x2 = max_x1_x2;  % x2 <= 12
int: UB_x3 = max_x3_x4;  % x3 <= 16
int: UB_x4 = max_x3_x4;  % x4 <= 16


% Variables
var 0..UB_x1: x1;  % weekly training hours for group X1 (integer hours)
var 0..UB_x2: x2;  % weekly training hours for group X2 (integer hours)
var 0..UB_x3: x3;  % weekly training hours for group X3 (integer hours)
var 0..UB_x4: x4;  % weekly training hours for group X4 (integer hours)

var int: total_fatigue; % total fatigue score to be minimized


% Constraints
% --- Availability / capacity constraints ---
constraint x1 + x2 <= max_x1_x2; % combined hours for X1 and X2 cannot exceed limit
constraint x3 + x4 <= max_x3_x4; % combined hours for X3 and X4 cannot exceed limit

% --- Minimum focus requirements ---
constraint x1 + x3 >= min_x1_x3; % ensure enough combined focus on X1 and X3
constraint x2 + x4 >= min_x2_x4; % ensure enough combined focus on X2 and X4

% --- Total fatigue definition ---
constraint
  total_fatigue = fatigue_x1 * x1
                + fatigue_x2 * x2
                + fatigue_x3 * x3
                + fatigue_x4 * x4;


% Objective
solve minimize total_fatigue;