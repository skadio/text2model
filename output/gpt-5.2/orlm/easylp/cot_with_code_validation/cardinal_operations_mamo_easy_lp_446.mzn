% Parameters
int: costX = 20;
int: costY = 30;

int: lbX = 0;
int: ubX = 1000;
int: lbY = 0;
int: ubY = 500;

int: rhs1 = 60;        % 5X + 3Y >= 60
int: rhs2 = 80;        % 4X + 1Y <= 80
int: min_diff = 10;    % X - Y >= 10

% Variables
var lbX..ubX: x;
var lbY..ubY: y;
var int: total_cost;

% Constraints
constraint 5*x + 3*y >= rhs1;
constraint 4*x + y <= rhs2;
constraint x - y >= min_diff;

% Objective value
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];