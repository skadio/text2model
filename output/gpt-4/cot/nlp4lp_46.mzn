% Parameters
int: N; % Number of different raw materials
int: M; % Number of different products
array[1..N] of int: Available; % Amount of raw material i available
array[1..N, 1..M] of int: Requirements; % Amount of raw material i required to produce one unit of product j
array[1..M] of int: Prices; % Price at which product j can be sold
array[1..M] of int: Costs; % Cost of producing one unit of product j
array[1..M] of int: Demands; % Demand for product j

% Variables
array[1..M] of var 0..max(Demands): Production; % Number of each product to produce

% Constraints
constraint forall(i in 1..N)(sum(j in 1..M)(Requirements[i,j]*Production[j]) <= Available[i]);
constraint forall(j in 1..M)(Production[j] <= Demands[j]);

% Objective
var int: Profit = sum(j in 1..M)(Prices[j]*Production[j] - Costs[j]*Production[j]);
solve maximize Profit;