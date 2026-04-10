% Resource allocation between initiatives X and Y

var 0..350: X;        % units allocated to initiative X (integer, capped at 350)
var 0..500: Y;        % units allocated to initiative Y (integer)

constraint X + Y <= 500;        % total resources limit
constraint X >= Y + 100;        % X at least 100 more than Y

var int: total_cost = 20 * X + 10 * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];