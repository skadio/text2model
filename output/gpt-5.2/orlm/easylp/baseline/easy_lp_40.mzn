% Finance investment allocation (amounts in thousands of dollars, integers)

int: minX = 10;          % $10,000
int: minY = 5;           % $5,000
int: minTotal = 20;      % $20,000

int: maxReturn = 5000;   % limit on 3*X + 4*Y (in thousand-$ return units)

int: costX = 100;        % $ per unit of return for X
int: costY = 200;        % $ per unit of return for Y

var int: x;  % investment in X (thousands of dollars)
var int: y;  % investment in Y (thousands of dollars)

constraint x >= minX;
constraint y >= minY;
constraint x + y >= minTotal;

% Return-cap constraint
constraint 3*x + 4*y <= maxReturn;

% Total cost in dollars:
% Each thousand dollars invested in X yields 3 return units; in Y yields 4 return units.
% Cost = (cost per return unit) * (return units)
var int: total_cost = costX*(3*x) + costY*(4*y);

solve minimize total_cost;

output [
  "x_thousand = ", show(x), "\n",
  "y_thousand = ", show(y), "\n",
  "total_cost_dollars = ", show(total_cost), "\n"
];