% Production Planning Model

% Data:
% M: Number of goods produced by the firm.
% N: Number of raw materials used by the firm.
% Available: array[1..N] of int, available amount for each raw material.
% Requirements: array[1..M, 1..N] of int, amount of raw material i required to produce one unit of good j.
% Prices: array[1..M] of int, revenue earned per unit of good j produced.

int: M;
int: N;
array[1..N] of int: Available;
array[1..M, 1..N] of int: Requirements;
array[1..M] of int: Prices;

% Decision variables:
% production[j] is the number of units produced for good j.
% A safe upper bound is provided (here 0..1000), but it can be adjusted.
array[1..M] of var 0..1000: production;

% Resource usage constraints:
% For each raw material i, ensure that the total consumption does not exceed Available[i].
constraint 
  forall(i in 1..N) (
    sum(j in 1..M)( Requirements[j,i] * production[j] ) <= Available[i]
  );

% Objective: Maximize total revenue.
var int: totalRevenue = sum(j in 1..M)( Prices[j] * production[j] );

solve maximize totalRevenue;

output [
  "Production = ", show(production), "\n",
  "Total Revenue = ", show(totalRevenue)
];