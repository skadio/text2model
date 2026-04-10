include "globals.mzn";

% Birdie Valley fertilizer blending (min cost subject to nutrient % ranges)
% Data embedded from problem statement.

int: F = 5;

array[1..F] of int: Ni = [10,  8, 12, 10, 15];  % nitrogen %
array[1..F] of int: Ph = [ 8, 11,  7, 10, 10];  % phosphorus %
array[1..F] of int: Po = [12, 15, 12, 10,  6];  % potash %

% Prices per 100 lb in cents to keep everything integer
array[1..F] of int: price100_cents = [2175, 2350, 2200, 1950, 1850];

% We optimize a 100-lb batch; cost per pound = total_cost_cents / 100.
% Decision variables: x[i] pounds of fertilizer i in the 100-lb blend.
array[1..F] of var 0..100: x;
constraint sum(i in 1..F)(x[i]) = 100;

% Nutrient percentage constraints:
% target ranges: Ni in [10,10.5], Ph in [8,8.5], Po in [12,12.5]
% On 100 lb total, "percent" equals "pounds of nutrient".
% Use integer inequalities by multiplying by 2 to represent 0.5%.
constraint 2 * sum(i in 1..F)(Ni[i] * x[i]) >= 2 * 10 * 100;
constraint 2 * sum(i in 1..F)(Ni[i] * x[i]) <= 2 * 10 * 100 + 1 * 100; % +0.5% => +0.5*100 = 50 => *2 gives +100

constraint 2 * sum(i in 1..F)(Ph[i] * x[i]) >= 2 *  8 * 100;
constraint 2 * sum(i in 1..F)(Ph[i] * x[i]) <= 2 *  8 * 100 + 1 * 100;

constraint 2 * sum(i in 1..F)(Po[i] * x[i]) >= 2 * 12 * 100;
constraint 2 * sum(i in 1..F)(Po[i] * x[i]) <= 2 * 12 * 100 + 1 * 100;

% Objective: minimize total cost (in cents) for the 100-lb blend.
% price100_cents is per 100 lb, so per-lb is price100_cents/100.
var int: total_cost_cents =
  sum(i in 1..F)(x[i] * price100_cents[i]) div 100;

solve minimize total_cost_cents;

output [
  "Blend amounts (lb) x = ", show(x), "\n",
  "Total cost for 100 lb (cents) = ", show(total_cost_cents), "\n",
  "Cost per lb (cents) = ", show(total_cost_cents), "\n",
  "Cost per 100 lb (dollars) = ", show(total_cost_cents/100.0), "\n",
  "Resulting Ni% = ", show((sum(i in 1..F)(Ni[i]*x[i]))/100.0), "\n",
  "Resulting Ph% = ", show((sum(i in 1..F)(Ph[i]*x[i]))/100.0), "\n",
  "Resulting Po% = ", show((sum(i in 1..F)(Po[i]*x[i]))/100.0), "\n"
];