% Taco stand profit maximization (all data embedded)

% Decision variables: number of tacos (nonnegative integers)
var 0..50: x1;   % regular tacos (demand cap 50)
var 0..40: x2;   % deluxe tacos  (demand cap 40)

% Supply limit: at most 70 total tacos
constraint x1 + x2 <= 70;

% Profit in cents to avoid floating-point issues
int: p1 = 250;   % $2.50
int: p2 = 355;   % $3.55
var 0..(p1*50 + p2*40): profit_cents = p1*x1 + p2*x2;

solve maximize profit_cents;

output [
  "Regular tacos (x1) = ", show(x1), "\n",
  "Deluxe tacos  (x2) = ", show(x2), "\n",
  "Total tacos        = ", show(x1 + x2), "\n",
  "Profit ($)         = ", show(profit_cents div 100), ".",
                         if (profit_cents mod 100) < 10 then "0" else "" endif,
                         show(profit_cents mod 100), "\n"
];