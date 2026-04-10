% Parameters
int: K; % Number of available alloys
int: M; % Number of metals/components

int: AlloyQuantity; % Total quantity (lb) of final alloy to produce

array[1..M] of int: Target; % Target quantity (lb) of each metal in the final alloy

array[1..K, 1..M] of float: Ratio; % Fraction of metal m in alloy k (by weight)

array[1..K] of float: Price; % Price per lb (or per unit) of alloy k


% Variables
array[1..K] of var 0..AlloyQuantity: use_qty; % Quantity (lb) of each alloy k to use
var float: total_cost; % Total cost of the chosen blend


% Constraints

% Total blend quantity must equal required final alloy quantity
constraint
  sum(k in 1..K)(use_qty[k]) = AlloyQuantity;

% Metal composition constraints: match target lb of each metal
constraint
  forall(m in 1..M) (
    sum(k in 1..K)(int2float(use_qty[k]) * Ratio[k, m]) = int2float(Target[m])
  );

% Define total cost from chosen quantities and per-unit prices
constraint
  total_cost = sum(k in 1..K)(int2float(use_qty[k]) * Price[k]);


% Objective
solve minimize total_cost;