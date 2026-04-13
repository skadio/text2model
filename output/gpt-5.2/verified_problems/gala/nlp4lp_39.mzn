% Alloy blending / least-cost mix
% Data is provided via .dzn:
%   int: K; int: M; float/int: AlloyQuantity;
%   array[1..M] of float/int: Target;
%   array[1..K,1..M] of float/int: Ratio;
%   array[1..K] of float/int: Price;

include "globals.mzn";

int: K;
int: M;

% Use float to handle fractional ratios/prices naturally
float: AlloyQuantity;
array[1..M] of float: Target;
array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

% Decision variables: amount (lb) of each available alloy to melt
array[1..K] of var float: x;

% Total cost
var float: total_cost = sum(k in 1..K)(Price[k] * x[k]);

% Nonnegativity
constraint forall(k in 1..K)(x[k] >= 0.0);

% Must produce the required total amount
constraint sum(k in 1..K)(x[k]) = AlloyQuantity;

% Meet exact target quantity for each metal
constraint forall(m in 1..M)(
  sum(k in 1..K)(Ratio[k,m] * x[k]) = Target[m]
);

solve minimize total_cost;

output [
  "x (lb per alloy) = ", show(x), "\n",
  "total_cost = ", show(total_cost), "\n",
  "metal_totals = ", show([sum(k in 1..K)(Ratio[k,m]*x[k]) | m in 1..M]), "\n"
];