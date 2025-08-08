include "globals.mzn";

int: A;  % Total number of different alloys
int: S;  % Total number of different steel types
array[1..A] of int: AvailableAlloy;  % Available amount of alloy a
array[1..A] of float: CarbonContent;  % Carbon content of alloy a
array[1..A] of float: NickelContent;  % Nickel content of alloy a
array[1..A] of float: AlloyPrice;     % Price of alloy a
array[1..S] of float: SteelPrice;     % Price of steel type s
array[1..S] of float: CarbonMin;      % Minimum required carbon content for steel type s
array[1..S] of float: NickelMax;      % Maximum allowed nickel content for steel type s

% Decision variables
array[1..A] of var 0..max(AvailableAlloy): alloy_used;  % Amount of each alloy used
array[1..S] of var 0..max(AvailableAlloy): steel_produced;  % Amount of each steel type produced

% Constraints
% Carbon content constraint for each steel type
constraint forall(s in 1..S)(
    sum(a in 1..A)(alloy_used[a] * CarbonContent[a]) / sum(a in 1..A)(alloy_used[a]) >= CarbonMin[s] -> 
    sum(a in 1..A)(alloy_used[a] * CarbonContent[a]) > 0
);

% Nickel content constraint for each steel type
constraint forall(s in 1..S)(
    sum(a in 1..A)(alloy_used[a] * NickelContent[a]) / sum(a in 1..A)(alloy_used[a]) <= NickelMax[s] -> 
    sum(a in 1..A)(alloy_used[a] * NickelContent[a]) > 0
);

% Limit on alloy 1 usage
constraint forall(s in 1..S)(alloy_used[1] <= 0.4 * sum(a in 1..A)(alloy_used[a]));

% Available alloy constraint
constraint forall(a in 1..A)(
    alloy_used[a] <= AvailableAlloy[a]
);

% Objective function: Maximize profit
var float: profit = sum(s in 1..S)(SteelPrice[s] * steel_produced[s]) - sum(a in 1..A)(AlloyPrice[a] * alloy_used[a]);

solve maximize profit;

% Output
output [
    "Alloy used: ", show(alloy_used), "\n",
    "Steel produced: ", show(steel_produced), "\n",
    "Profit: ", show(profit), "\n"
];