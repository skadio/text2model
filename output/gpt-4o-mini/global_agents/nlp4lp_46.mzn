include "globals.mzn";

int: N;  % Number of different raw materials
int: M;  % Number of different products
array[1..N] of int: Available;  % Amount of raw material i available
array[1..N, 1..M] of int: Requirements;  % Amount of raw material i required to produce one unit of product j
array[1..M] of int: Prices;  % Price at which product j can be sold
array[1..M] of int: Costs;  % Cost of producing one unit of product j
array[1..M] of int: Demands;  % Demand for product j

% Decision variables: number of units to produce for each product
array[1..M] of var 0..max(Demands): production;

% Objective: Maximize profit
var int: profit = sum(j in 1..M)( (Prices[j] - Costs[j]) * production[j] );

% Constraints: Resource availability
constraint forall(i in 1..N)(
    sum(j in 1..M)( Requirements[i,j] * production[j] ) <= Available[i]
);

% Constraints: Demand limits
constraint forall(j in 1..M)(
    production[j] <= Demands[j]
);

% Solve & output
solve maximize profit;
output [ "Production = ", show(production), "\nProfit = ", show(profit), "\n" ];