% Investment allocation: minimize total cost score
% Option X cost per unit = 7
% Option Y cost per unit = 9

var 0..300: x;  % units invested in X (integer)
var 0..300: y;  % units invested in Y (integer)

constraint 4*x + 5*y <= 1000;   % risk tolerance
constraint 3*x - 2*y >= 200;    % balance requirement
constraint x + y <= 300;        % resource limit

var int: total_cost = 7*x + 9*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];