int: K;                          % Number of Alloys
int: M;                          % Number of Metals
int: AlloyQuantity;             % Quantity of alloy to produce
array[1..M] of int: Target;     % Target quantities of each metal
array[1..K, 1..M] of float: Ratio; % Ratio of each component in the alloys
array[1..K] of float: Price;    % Price of each alloy

% Decision variables: quantity of each alloy to use
array[1..K] of var 0..AlloyQuantity: quantity;

% Constraints to ensure the target quantities are met
array[1..M] of var 0..AlloyQuantity: metalQuantity;

% Calculate the total quantity of each metal from the selected alloys
constraint forall(m in 1..M) (
    metalQuantity[m] = sum(k in 1..K)(quantity[k] * Ratio[k, m])
);

% Ensure that the total quantity of each metal meets the target
constraint forall(m in 1..M) (
    metalQuantity[m] = Target[m]
);

% Objective: Minimize the total cost of the alloys used
var float: totalCost = sum(k in 1..K)(Price[k] * quantity[k]);
solve minimize totalCost;

% Output the results
output [
    "Quantities of alloys: ", show(quantity), "\n",
    "Total cost: ", show(totalCost), "\n"
];