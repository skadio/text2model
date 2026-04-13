% Manufacturing plan: minimize cost subject to capacity, demand, and x >= y.
% All data embedded as requested.

int: cap = 300;        % total units capacity
int: a = 3;            % demand coefficient for X
int: b = 4;            % demand coefficient for Y
int: demand = 800;     % minimum combined demand measure
int: cX = 50;          % cost per unit of X
int: cY = 70;          % cost per unit of Y

var 0..cap: x;         % units of product X (integer)
var 0..cap: y;         % units of product Y (integer)

constraint x + y <= cap;
constraint a * x + b * y >= demand;
constraint x >= y;

var int: total_cost = cX * x + cY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];