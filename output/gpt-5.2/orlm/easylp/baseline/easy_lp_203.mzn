int: total_investment = 1000000;

array[1..3] of int: min_invest = [200000, 150000, 250000]; % X, Y, Z

% Returns per dollar invested, scaled by 100 to keep integer arithmetic:
% X: 2% -> 2/100, Y: 3% -> 3/100, Z: 4% -> 4/100
array[1..3] of int: return_rate_x100 = [2, 3, 4];

array[1..3] of var int: invest;
constraint forall(i in 1..3)(invest[i] >= min_invest[i]);
constraint sum(i in 1..3)(invest[i]) = total_investment;

% Total return in dollars, scaled by 100 (i.e., cents)
var int: total_return_x100 = sum(i in 1..3)(return_rate_x100[i] * invest[i]);

solve minimize total_return_x100;

% Rounded to nearest dollar:
% total_return_x100 is in cents, so rounding to nearest dollar is:
var int: rounded_return_dollars = (total_return_x100 + 50) div 100;

output [
  "Investments (X,Y,Z) = ", show(invest), "\n",
  "Total return (cents) = ", show(total_return_x100), "\n",
  "Minimum total return rounded to nearest dollar = $", show(rounded_return_dollars), "\n"
];