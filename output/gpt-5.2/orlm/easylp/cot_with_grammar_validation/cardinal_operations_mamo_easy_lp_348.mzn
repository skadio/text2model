% Parameters
int: total_fund = 100000;

set of int: P = 1..4;
array[P] of int: min_invest = [20000, 15000, 25000, 40000];

% Fees as exact rational numbers to avoid floating issues:
% X: 0.05 = 5/100, Y: 0.07 = 7/100, Z: 0.06 = 6/100, W: 0.09 = 9/100
array[P] of int: fee_num = [5, 7, 6, 9];
int: fee_den = 100;

% Variables
array[P] of var 0..total_fund: invest;
var 0..total_fund: total_fee_rounded;

% Constraints
constraint sum(p in P)(invest[p]) = total_fund;

constraint forall(p in P) (
  invest[p] >= min_invest[p]
);

% total_fee_rounded = round( sum_p invest[p]*fee_num[p]/fee_den )
% Implement rounding by: total_fee_rounded = floor( (2*sum_num + fee_den) / (2*fee_den) )
% where sum_num = sum_p invest[p]*fee_num[p]
var 0..(total_fund * max(fee_num)): sum_num;
constraint sum_num = sum(p in P)(invest[p] * fee_num[p]);

constraint total_fee_rounded = (2 * sum_num + fee_den) div (2 * fee_den);

% Objective
solve minimize total_fee_rounded;