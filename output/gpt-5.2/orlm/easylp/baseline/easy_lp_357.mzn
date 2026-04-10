% Inventory planning - minimize total cost
% All data embedded in model

var 0..250: x1;
var 0..250: x2;
var 0..150: x3;
var 0..150: x4;

constraint x1 + x2 <= 500;
constraint x3 + x4 <= 300;
constraint x1 + x3 >= 200;
constraint x2 + x4 >= 100;

% Costs in cents to keep objective integer:
% x1: $1.5 -> 150 cents, x2: $2 -> 200, x3: $3 -> 300, x4: $4 -> 400
var int: total_cost_cents = 150*x1 + 200*x2 + 300*x3 + 400*x4;

solve minimize total_cost_cents;

% Rounded-to-nearest-dollar cost:
% dollars = cents/100. Round: floor((cents + 50)/100)
var int: rounded_cost_dollars = (total_cost_cents + 50) div 100;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost_cents=", show(total_cost_cents), "\n",
  "total_cost_dollars=", show(total_cost_cents div 100), ".", 
    if (total_cost_cents mod 100) < 10 then "0" else "" endif, show(total_cost_cents mod 100), "\n",
  "rounded_cost_dollars=", show(rounded_cost_dollars), "\n"
];