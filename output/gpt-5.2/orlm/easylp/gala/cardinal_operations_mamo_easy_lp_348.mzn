% Investment allocation with minimums; minimize annual management fees.
% Data is embedded as requested.

include "globals.mzn";

int: total_fund = 100000;

set of int: P = 1..4;
int: X = 1;
int: Y = 2;
int: Z = 3;
int: W = 4;

array[P] of int: min_invest = [20000, 15000, 25000, 40000];

% Fee rates expressed as cents per dollar to keep the model integral:
% 0.05 -> 5 cents, 0.07 -> 7 cents, 0.06 -> 6 cents, 0.09 -> 9 cents.
array[P] of int: fee_cents_per_dollar = [5, 7, 6, 9];

array[P] of var 0..total_fund: invest;

constraint forall(p in P)(invest[p] >= min_invest[p]);
constraint sum(p in P)(invest[p]) = total_fund;

var 0..(total_fund * max(fee_cents_per_dollar)): total_fee_cents =
  sum(p in P)(fee_cents_per_dollar[p] * invest[p]);

% Minimize total annual management fee (in cents).
solve minimize total_fee_cents;

% Rounded to nearest dollar:
% fee_dollars_exact = total_fee_cents / 100
% rounded = floor((total_fee_cents + 50)/100)
var 0..(total_fund * max(fee_cents_per_dollar) div 100 + 1): fee_rounded_dollars =
  (total_fee_cents + 50) div 100;

output [
  "Investment X = $", show(invest[X]), "\n",
  "Investment Y = $", show(invest[Y]), "\n",
  "Investment Z = $", show(invest[Z]), "\n",
  "Investment W = $", show(invest[W]), "\n",
  "Total fee (cents) = ", show(total_fee_cents), "\n",
  "Total fee (rounded to nearest dollar) = $", show(fee_rounded_dollars), "\n"
];