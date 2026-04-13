% Parameters
int: total_fund = 100000;

int: n = 4;
set of int: P = 1..n;

array[P] of int: min_invest = [20000, 15000, 25000, 40000]; % X,Y,Z,W

% fees as integer "cents per dollar" to keep integrality:
% X: 0.05 -> 5, Y: 0.07 -> 7, Z: 0.06 -> 6, W: 0.09 -> 9
array[P] of int: fee_cents_per_dollar = [5, 7, 6, 9];

% Variables
array[P] of var 0..total_fund: invest;

% total fee in cents (bounded)
var 0..(max(fee_cents_per_dollar) * total_fund): total_fee_cents;

% Constraints
constraint forall(p in P) (invest[p] >= min_invest[p]);
constraint sum(p in P)(invest[p]) = total_fund;

constraint total_fee_cents = sum(p in P)(fee_cents_per_dollar[p] * invest[p]);

% Objective
solve minimize total_fee_cents;

% (Optional output) fee in dollars rounded to nearest dollar:
% Since 1 cent = $0.01, rounding dollars = round(total_fee_cents/100)
output [
  "investments = ", show(invest), "\n",
  "total_fee_cents = ", show(total_fee_cents), "\n",
  "total_fee_rounded_dollars = ", show((total_fee_cents + 50) div 100), "\n"
];