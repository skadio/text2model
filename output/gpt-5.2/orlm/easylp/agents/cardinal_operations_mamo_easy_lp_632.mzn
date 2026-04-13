% Parameters
% Fatigue score per hour for each session
int: fatigue_x1 = 1000;
int: fatigue_x2 = 1500;
int: fatigue_x3 = 2000;
int: fatigue_x4 = 2500;

% Weekly hour limits for grouped sessions
int: max_x1_x2 = 20;  % x1 + x2 <= 20
int: max_x3_x4 = 15;  % x3 + x4 <= 15

% Minimum balance requirements
int: min_x1_x3 = 10;  % x1 + x3 >= 10
int: min_x2_x4 = 8;   % x2 + x4 >= 8


% Variables
% Weekly allocated hours for each training session (whole numbers, non-negative)
var 0..max_x1_x2: x1;  % endurance hours
var 0..max_x1_x2: x2;  % strength hours
var 0..max_x3_x4: x3;  % agility hours
var 0..max_x3_x4: x4;  % tactics hours

% Total fatigue score (integer because all inputs and decisions are integer)
var int: total_fatigue;


% Constraints

% --- Grouped weekly hour upper limits ---
constraint x1 + x2 <= max_x1_x2;   % Endurance + Strength cannot exceed 20 hours
constraint x3 + x4 <= max_x3_x4;   % Agility + Tactics cannot exceed 15 hours

% --- Minimum balance requirements ---
constraint x1 + x3 >= min_x1_x3;   % Endurance + Agility must be at least 10 hours
constraint x2 + x4 >= min_x2_x4;   % Strength + Tactics must be at least 8 hours

% --- Define total fatigue score from allocations ---
constraint
  total_fatigue =
    fatigue_x1 * x1 +
    fatigue_x2 * x2 +
    fatigue_x3 * x3 +
    fatigue_x4 * x4;


% Objective
solve minimize total_fatigue;