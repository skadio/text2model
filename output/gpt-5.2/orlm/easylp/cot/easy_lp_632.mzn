% Parameters (with values embedded)
int: n = 4;
set of int: S = 1..n;

array[S] of int: fatigue = [1000, 1500, 2000, 2500];

% No explicit per-session upper bounds were provided in the description.
% Allocations must be whole numbers and are naturally non-negative.
int: max_hours = 20; % safe global upper bound from constraints (x1+x2 <= 20)

% Variables
array[S] of var 0..max_hours: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4
var int: total_fatigue;

% Constraints
constraint x[1] + x[2] <= 20;        % endurance + strength
constraint x[3] + x[4] <= 15;        % agility + tactics
constraint x[1] + x[3] >= 10;        % endurance + agility minimum
constraint x[2] + x[4] >= 8;         % strength + tactics minimum

constraint total_fatigue = sum(i in S)(fatigue[i] * x[i]);

% Objective
solve minimize total_fatigue;