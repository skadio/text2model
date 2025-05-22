% Parameters
int: K;                                % Number of food types
int: M;                                % Number of nutrients

array[1..K] of float: Price;           % Price of each food type
array[1..M] of float: Demand;          % Required amount of each nutrient
array[1..K, 1..M] of float: Nutrition; % Nutrient content of each food type

% Variables
array[1..K] of var float: x;           % Amount of each food to purchase

% Constraints
constraint
    forall(k in 1..K)( x[k] >= 0.0 );                                   % Non-negativity
constraint
    forall(m in 1..M)(                                                   % Meet every nutrient demand
        sum(k in 1..K)( Nutrition[k, m] * x[k] ) >= Demand[m]
    );

% Objective
var float: TotalCost = sum(k in 1..K)( Price[k] * x[k] );
solve minimize TotalCost;