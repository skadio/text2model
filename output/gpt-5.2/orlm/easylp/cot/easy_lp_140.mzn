% Parameters (with values embedded)
int: max_logistics = 50;          % 2*X + 3*Y <= 50
int: min_strength = 10;           % 5*X + 1*Y >= 10
int: max_diff = 5;                % |X - Y| <= 5
int: costX = 10;                  % in thousands: $10000 -> 10
int: costY = 20;                  % in thousands: $20000 -> 20

% Variables
var 0..25: X;                     % from 2*X <= 50
var 0..16: Y;                     % from 3*Y <= 50

% Constraints
constraint 2*X + 3*Y <= max_logistics;
constraint 5*X + Y >= min_strength;
constraint abs(X - Y) <= max_diff;

% Objective
var int: total_cost = costX*X + costY*Y;
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost(thousands)=", show(total_cost), "\n",
  "min_total_cost(dollars)=", show(1000*total_cost), "\n"
];