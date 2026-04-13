% Parameters
int: fatigue_x1 = 2;          % Fatigue per hour for training group x1
int: fatigue_x2 = 3;          % Fatigue per hour for training group x2
int: fatigue_x3 = 4;          % Fatigue per hour for training group x3
int: fatigue_x4 = 5;          % Fatigue per hour for training group x4

int: max_x1 = 60;             % Upper bound on hours for x1
int: max_x2 = 70;             % Upper bound on hours for x2
int: max_x3 = 80;             % Upper bound on hours for x3
int: max_x4 = 90;             % Upper bound on hours for x4

int: cap_x1x2 = 100;          % Constraint: x1 + x2 <= 100
int: min_x3x4 = 50;           % Constraint: x3 + x4 >= 50
int: eq_2x1_minus_x2 = 30;    % Constraint: 2*x1 - x2 = 30
int: max_halfx4_minus_x3 = 20;% Constraint: (x4/2) - x3 <= 20

% Variables
var 0..max_x1: x1;            % Integer hours allocated to training group x1
var 0..max_x2: x2;            % Integer hours allocated to training group x2
var 0..max_x3: x3;            % Integer hours allocated to training group x3
var 0..max_x4: x4;            % Integer hours allocated to training group x4

var int: total_fatigue;       % Total fatigue score (objective value)
var int: rounded_fatigue;     % Total fatigue rounded to nearest integer (same as total_fatigue since int)

% Constraints
% --- Total fatigue definition ---
constraint
  total_fatigue =
    fatigue_x1 * x1 + fatigue_x2 * x2 + fatigue_x3 * x3 + fatigue_x4 * x4;

% --- Training hours capacity constraints ---
constraint
  x1 + x2 <= cap_x1x2;                 % Combined hours for x1 and x2 cannot exceed cap

constraint
  x3 + x4 >= min_x3x4;                 % Combined hours for x3 and x4 must be at least minimum

% --- Exact relationship between x1 and x2 ---
constraint
  2 * x1 - x2 = eq_2x1_minus_x2;       % Twice x1 minus x2 equals specified value

% --- Half of x4 minus x3 must not exceed a limit ---
% Avoid fractional division by rewriting:
% (x4/2) - x3 <= K  <=>  x4 - 2*x3 <= 2*K
constraint
  x4 - 2 * x3 <= 2 * max_halfx4_minus_x3;

% --- Rounded fatigue (already integer, so identical) ---
constraint
  rounded_fatigue = total_fatigue;

% Objective
solve minimize total_fatigue;