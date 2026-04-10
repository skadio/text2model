% Investment allocation minimizing annual management fees

int: total_fund = 100000;

set of int: P = 1..4;
int: X = 1;
int: Y = 2;
int: Z = 3;
int: W = 4;

array[P] of int: min_invest = [20000, 15000, 25000, 40000];

% Fee rates as integers in basis points (1 bp = 0.0001)
% 0.05=5000 bp, 0.07=7000 bp, 0.06=6000 bp, 0.09=9000 bp
array[P] of int: fee_bp = [5000, 7000, 6000, 9000];

array[P] of var int: invest;
constraint forall(p in P) (invest[p] >= min_invest[p]);
constraint sum(p in P)(invest[p]) = total_fund;

% Minimize total fee in basis-point dollars: sum(invest * fee_bp)
var int: total_fee_bp_dollars = sum(p in P)(invest[p] * fee_bp);
solve minimize total_fee_bp_dollars;

% Report rounded to nearest dollar:
% fee_dollars = total_fee_bp_dollars / 10000
% rounded = floor((total_fee_bp_dollars + 5000) / 10000)
var int: total_fee_rounded =
  (total_fee_bp_dollars + 5000) div 10000;

output [
  "Investments (X,Y,Z,W) = ", show([invest[X], invest[Y], invest[Z], invest[W]]), "\n",
  "Total annual management fee (rounded to nearest dollar) = $", show(total_fee_rounded), "\n"
];