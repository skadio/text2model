% Taco stand profit maximization

var 0..50: x1; % regular tacos
var 0..40: x2; % deluxe tacos

% Supplies constraint: at most 70 tacos total
constraint x1 + x2 <= 70;

% Maximize profit (use cents to keep it integer)
var int: profit_cents = 250 * x1 + 355 * x2;

solve maximize profit_cents;

output [
  "regular_tacos = ", show(x1), "\n",
  "deluxe_tacos  = ", show(x2), "\n",
  "profit        = $", show(profit_cents div 100), ".", 
  if (profit_cents mod 100) < 10 then "0" else "" endif, 
  show(profit_cents mod 100), "\n"
];