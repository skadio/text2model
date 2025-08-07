% Parameters (to be provided in the .dzn file)
int: K;                          % Number of food types
int: M;                          % Number of nutrients

array[1..K] of float: Price;     % Price per unit of each food type
array[1..M] of float: Demand;      % Required amount of each nutrient
array[1..K, 1..M] of float: Nutrition; % Amount of nutrient m in one unit of food k

% Decision variables: amount of each food to purchase.
% We assume food amounts are continuous and non-negative.
array[1..K] of var 0.0..1e6: x;

% Total cost of the diet
var float: TotalCost = sum(k in 1..K)( Price[k] * x[k] );

% Constraint: For each nutrient, the total amount supplied must meet the demand.
constraint
  forall(m in 1..M)(
    sum(k in 1..K)( Nutrition[k, m] * x[k] ) >= Demand[m]
  );

% Solve: Minimize the total cost
solve minimize TotalCost;

% Output the solution: amounts of food to purchase and the total cost
output [
  "Food amounts: ", show(x), "\n",
  "Total cost: ", show(TotalCost), "\n"
];