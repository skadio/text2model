include "globals.mzn";

% Parameters (from data file)
int: A;  % number of alloys
int: S;  % number of steel types

array[1..A] of float: AvailableAlloy;   % available amount for each alloy
array[1..A] of float: CarbonContent;      % carbon percentage in each alloy
array[1..A] of float: NickelContent;      % nickel percentage in each alloy
array[1..A] of float: AlloyPrice;         % purchase price per ton for each alloy

array[1..S] of float: SteelPrice;         % selling price per ton for each steel type
array[1..S] of float: CarbonMin;          % minimum required carbon percentage for steel type
array[1..S] of float: NickelMax;          % maximum allowed nickel percentage for steel type

% Define a common upper bound for production amounts.
float: TotalAvailable = sum(a in 1..A)(AvailableAlloy[a]);

% Decision Variables:
% X[s,a]: amount of alloy a used in producing steel type s.
array[1..S, 1..A] of var 0.0..TotalAvailable: X;
% Y[s]: total production (tons) of steel type s.
array[1..S] of var 0.0..TotalAvailable: Y;

% Linking production with alloy usage:
constraint forall(s in 1..S)(
    Y[s] = sum(a in 1..A)(X[s, a])
);

% Quality Constraints for each steel type:
% 1. The produced steel must have at least the required carbon percentage.
constraint forall(s in 1..S)(
    sum(a in 1..A)(X[s, a] * CarbonContent[a]) >= CarbonMin[s] * Y[s]
);
% 2. The produced steel must have at most the allowed nickel percentage.
constraint forall(s in 1..S)(
    sum(a in 1..A)(X[s, a] * NickelContent[a]) <= NickelMax[s] * Y[s]
);

% Additional constraint: In every steel, alloy 1 must be at most 40% of the steel.
constraint forall(s in 1..S)(
    X[s, 1] <= 0.4 * Y[s]
);

% Capacity Constraints:
% The total amount of each alloy used across all steel types cannot exceed its available amount.
constraint forall(a in 1..A)(
    sum(s in 1..S)(X[s, a]) <= AvailableAlloy[a]
);

% Objective: maximize profit = total revenue from steel - total cost of alloys.
var float: profit = sum(s in 1..S)(SteelPrice[s] * Y[s])
                      - sum(a in 1..A)(AlloyPrice[a] * sum(s in 1..S)(X[s, a]));

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Steel Production (per type): ", show(Y), "\n",
  "Alloy Usage Matrix (each row corresponds to a steel type):\n",
  concat([ "Steel type ", show(s), ": " , show([ X[s, a] | a in 1..A ]), "\n"
           | s in 1..S])
];