% Parameters
int: nSessions = 4;                          % Number of training sessions (x1..x4)
set of int: SESSIONS = 1..nSessions;         % Index set for sessions

array[SESSIONS] of int: fatigue = [1000, 1500, 2000, 2500];  % Fatigue per hour for x1..x4

int: max_x1_x2 = 20;                         % Max combined hours for sessions x1 and x2
int: max_x3_x4 = 15;                         % Max combined hours for sessions x3 and x4
int: min_x1_x3 = 10;                         % Min combined hours for sessions x1 and x3
int: min_x2_x4 = 8;                          % Min combined hours for sessions x2 and x4

% Bounds on weekly allocation (non-negative; big-M caps for safety)
array[SESSIONS] of int: lb = [0, 0, 0, 0];    % Lower bounds (hours/week)
array[SESSIONS] of int: ub = [100, 100, 100, 100]; % Upper bounds (hours/week)

% Variables
array[SESSIONS] of var int: x;                % Hours allocated to each session (integer hours)
var int: total_fatigue;                       % Total fatigue score

% Constraints
% Enforce per-session bounds
constraint forall(i in SESSIONS) (x[i] >= lb[i] /\ x[i] <= ub[i]);

% Define objective expression
constraint total_fatigue = sum(i in SESSIONS)(fatigue[i] * x[i]);

% Capacity limits on combined weekly hours
constraint x[1] + x[2] <= max_x1_x2;          % Endurance + Strength <= 20
constraint x[3] + x[4] <= max_x3_x4;          % Agility + Tactics  <= 15

% Minimum balance requirements across session pairs
constraint x[1] + x[3] >= min_x1_x3;          % Endurance + Agility >= 10
constraint x[2] + x[4] >= min_x2_x4;          % Strength  + Tactics >= 8

% Objective
solve minimize total_fatigue;