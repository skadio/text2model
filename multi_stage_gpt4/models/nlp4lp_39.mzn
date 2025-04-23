% Parameters
int: K; % Number of Alloys
int: M; % Number of Metals
float: AlloyQuantity; % Quantity of alloy to produce
array[1..M] of float: Target; % Quantity of target components in the alloy
array[1..K, 1..M] of float: Ratio; % Ratio of each component k in the alloy m
array[1..K] of float: Price; % Price of each alloy k

% Variables
array[1..K] of var 0.0..AlloyQuantity: AlloyUsed; % Quantity of each alloy k used to produce the desired alloy

% Constraints

% The total quantity of alloys used should be equal to the desired quantity of alloy to produce
constraint sum(AlloyUsed) = AlloyQuantity;

% The quantity of each metal in the final alloy should be equal to the target quantity
constraint forall(m in 1..M)(
    sum(k in 1..K)(Ratio[k, m] * AlloyUsed[k]) = Target[m]
);

% The quantity of each alloy used should be non-negative
constraint forall(k in 1..K)(
    AlloyUsed[k] >= 0.0
);

% Objective
solve minimize sum(k in 1..K)(Price[k] * AlloyUsed[k]);