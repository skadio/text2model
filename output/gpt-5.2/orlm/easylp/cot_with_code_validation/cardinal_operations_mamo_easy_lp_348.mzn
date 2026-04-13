% Parameters
int: total_fund = 100000;
int: n = 4;
set of int: P = 1..n;

array[P] of int: min_invest = [20000, 15000, 25000, 40000];

% Fee rates scaled to avoid floats: fee_cents_per_dollar = round(rate * 100)
array[P] of int: fee_cents_per_dollar = [5, 7, 6, 9];

% Variables
array[P] of var 0..total_fund: invest;
var 0..(total_fund * max(fee_cents_per_dollar)): total_fee_cents;

% Constraints
constraint forall(p in P) (invest[p] >= min_invest[p]);
constraint sum(p in P)(invest[p]) = total_fund;

constraint total_fee_cents = sum(p in P)(fee_cents_per_dollar[p] * invest[p]);

% Objective
solve minimize total_fee_cents;

% Rounded to nearest dollar: (cents + 50) div 100
output [
  "Min total annual management fee (rounded to nearest dollar): ",
  show((total_fee_cents + 50) div 100), "\n",
  "Investments: X=", show(invest[1]), " Y=", show(invest[2]),
  " Z=", show(invest[3]), " W=", show(invest[4]), "\n"
];