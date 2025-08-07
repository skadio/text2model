% Diet optimisation – minimise cost while meeting nutrient demands
% ---------------------------------------------------------------

% ---------------------------------------------------
% Data – supplied from a .dzn file
% ---------------------------------------------------
int: K;                      % number of foods
int: M;                      % number of nutrients

array[1..K] of int: Price;           % price per unit of each food
array[1..M] of int: Demand;          % required amount of each nutrient
array[1..K, 1..M] of int: Nutrition; % nutrient content of each food

% ---------------------------------------------------
% Decision variables
% ---------------------------------------------------
array[1..K] of var int: qty;         % quantity of each food to buy

% ---------------------------------------------------
% Constraints
% ---------------------------------------------------
% Non‑negative quantities
constraint forall(k in 1..K)( qty[k] >= 0 );

% Nutrient requirements
constraint forall(m in 1..M)(
    sum(k in 1..K)( qty[k] * Nutrition[k,m] ) >= Demand[m]
);

% ---------------------------------------------------
% Objective – minimise total cost
% ---------------------------------------------------
var int: totalCost = sum(k in 1..K)( qty[k] * Price[k] );

% ---------------------------------------------------
% Solve statement
% ---------------------------------------------------
solve minimize totalCost;

% ---------------------------------------------------
% Output
% ---------------------------------------------------
output [
    "Total cost: ", show(totalCost), "\n",
    "Quantities: ", show(qty), "\n"
];