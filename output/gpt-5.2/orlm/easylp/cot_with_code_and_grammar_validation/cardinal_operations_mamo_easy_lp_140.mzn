% Parameters
int: cap_a = 50;              % 2*X + 3*Y <= 50
int: min_b = 10;              % 5*X + 1*Y >= 10
int: max_diff = 5;            % |X - Y| <= 5
int: costX = 10;              % in thousands: $10000
int: costY = 20;              % in thousands: $20000

% Variables
var 0..cap_a: X;
var 0..cap_a: Y;
var 0..(costX*cap_a + costY*cap_a): total_cost;

% Constraints
constraint 2*X + 3*Y <= cap_a;
constraint 5*X + Y >= min_b;
constraint abs(X - Y) <= max_diff;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;