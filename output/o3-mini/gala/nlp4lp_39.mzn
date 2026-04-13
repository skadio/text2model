% Alloy Mixing Optimization Model

% Data declarations (to be provided in a separate .dzn file)
int: K;                         % Number of available alloys
int: M;                         % Number of metals in the alloy
float: AlloyQuantity;           % Total quantity of alloy to produce (in lb)
array[1..M] of float: Target;   % Target quantity for each metal m
array[1..K, 1..M] of float: Ratio;  % Ratio of metal m in alloy k (each row should sum to 1)
array[1..K] of float: Price;    % Price per unit of each alloy k

% Decision variables: quantity (in lb) to use from each available alloy
array[1..K] of var 0.0..AlloyQuantity: x;

% Constraint: The total amount of alloys used must equal the AlloyQuantity.
constraint sum(k in 1..K)( x[k] ) = AlloyQuantity;

% Constraint: For each metal m, the sum of the metal contribution from
% each alloy must match the target required.
constraint
    forall(m in 1..M)(
        sum(k in 1..K)( Ratio[k, m] * x[k] ) = Target[m]
    );

% Define the objective: minimize total cost.
var float: cost = sum(k in 1..K)( Price[k] * x[k] );

solve minimize cost;

output [
    "Alloy quantities used: ", show(x), "\n",
    "Total cost: ", show(cost), "\n"
];