% Parameters
int: profit_A = 3;                 % profit per unit of product A (£)
int: profit_B = 5;                 % profit per unit of product B (£)

int: time_A_min = 12;              % assembly time per unit of A (minutes)
int: time_B_min = 25;              % assembly time per unit of B (minutes)

int: weekly_time_hours = 30;       % effective machine time per week (hours)
int: weekly_time_min = weekly_time_hours * 60;  % convert to minutes for consistency

% Technical ratio: for every 5 units of A, at least 2 units of B
int: ratio_A = 5;
int: ratio_B = 2;

% Variables
var 0..weekly_time_min div time_A_min: units_A;  % units of product A produced (bounded by time)
var 0..weekly_time_min div time_B_min: units_B;  % units of product B produced (bounded by time)

% Constraints
%--- Machine time capacity (weekly working time in minutes) ---
constraint
  time_A_min * units_A + time_B_min * units_B <= weekly_time_min;

%--- Technical production ratio: for every ratio_A units of A, at least ratio_B units of B ---
% Equivalent to: units_B >= (ratio_B/ratio_A) * units_A, written without fractions
constraint
  ratio_A * units_B >= ratio_B * units_A;

% Objective
solve maximize profit_A * units_A + profit_B * units_B;