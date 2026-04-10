% Investment allocation problem (all data embedded)

int: total_fund = 10000;
int: min_X = 2000;
int: min_Y = 3000;

% Returns per dollar (as rational numbers to avoid floating issues)
int: retX_num = 5;   % 0.05 = 5/100
int: retY_num = 8;   % 0.08 = 8/100
int: ret_den = 100;

var min_X..total_fund: x;  % dollars invested in X
var min_Y..total_fund: y;  % dollars invested in Y

constraint x + y = total_fund;

% Total return in dollars, represented as cents (integer)
var 0..100000000: return_cents;
constraint return_cents = retX_num * x + retY_num * y;

solve minimize return_cents;

output [
  "x = $", show(x), "\n",
  "y = $", show(y), "\n",
  "minimum_total_return = $", show(return_cents), "/", show(ret_den), "\n"
];