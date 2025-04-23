include "globals.mzn";

% Number of Alloys
int: K;

% Number of Metals
int: M;

% Quantity of alloy to produce
int: AlloyQuantity;

% Quantity of target components in the alloy
array[1..M] of int: Target;

% Ratio of each component k in the alloy m
array[1..K, 1..M] of float: Ratio;

% Price of each alloy k
array[1..K] of float: Price;

% Decision variable: quantity of each alloy to use
array[1..K] of var 0..AlloyQuantity: AlloyUse;

% Objective: minimize the total cost
var float: TotalCost = sum(k in 1..K)(Price[k] * AlloyUse[k]);

% Constraint: the total quantity of each metal in the final alloy must meet the target
constraint forall(m in 1..M)(
  sum(k in 1..K)(Ratio[k,m] * AlloyUse[k]) >= Target[m]
);

% Constraint: the total quantity of alloys used must not exceed the alloy quantity
constraint sum(k in 1..K)(AlloyUse[k]) <= AlloyQuantity;

% Solve
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Alloy use: "] ++ [show(AlloyUse[k]) | k in 1..K];