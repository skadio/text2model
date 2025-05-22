% Parameters
int: K; % Number of Alloys
int: M; % Number of Metals
int: AlloyQuantity; % Quantity of alloy to produce
array[1..M] of int: Target; % Quantity of target components in the alloy
array[1..K, 1..M] of float: Ratio; % Ratio of each component k in the alloy m
array[1..K] of float: Price; % Price of each alloy k

% Variables
array[1..K] of var 0..AlloyQuantity: Alloys; % Quantity of each alloy to be used

% Constraints
constraint forall(m in 1..M)(
  sum(k in 1..K)(Ratio[k,m]*Alloys[k]) >= Target[m]
);
constraint sum(k in 1..K)(Alloys[k]) = AlloyQuantity;

% Objective
var float: TotalCost = sum(k in 1..K)(Price[k]*Alloys[k]);
solve minimize TotalCost;