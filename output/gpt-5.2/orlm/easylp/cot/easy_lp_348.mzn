% Parameters (with values embedded)
int: total_fund = 100000;

set of int: P = 1..4;
int: X = 1;
int: Y = 2;
int: Z = 3;
int: W = 4;

array[P] of int: min_invest = [20000, 15000, 25000, 40000];

% Fee rates as exact rationals (rate = num/den)
array[P] of int: fee_num = [5, 7, 6, 9];
int: fee_den = 100;

% Variables
array[P] of var int: invest;                % whole dollars
var int: total_fee_cents;                   % objective in cents

% Constraints
constraint forall(p in P) (
  invest[p] >= min_invest[p]
);

constraint sum(p in P)(invest[p]) = total_fund;

% Total fee in cents = sum(invest * rate * 100) = sum(invest * fee_num)
constraint total_fee_cents = sum(p in P)(invest[p] * fee_num[p]);

% Objective
solve minimize total_fee_cents;

output [
  "Minimum annual management fee (rounded to nearest dollar): ",
  show((total_fee_cents + 50) div 100), "\n",
  "Exact fee in cents: ", show(total_fee_cents), "\n",
  "Investments: X=", show(invest[X]), " Y=", show(invest[Y]), " Z=", show(invest[Z]), " W=", show(invest[W]), "\n"
];