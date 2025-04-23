% Parameters
int: N; % Number of different raw materials
int: M; % Number of different products
array[1..N] of int: Available; % Amount of raw material i available
array[1..N, 1..M] of int: Requirements; % Amount of raw material i required to produce one unit of product j
array[1..M] of int: Prices; % Price at which product j can be sold
array[1..M] of int: Costs; % Cost of producing one unit of product j
array[1..M] of int: Demands; % Demand for product j

% Variables
array[1..M] of var 0..max(Demands): Products; % Number of each product to produce

% Constraints

% The number of each product produced should not exceed its demand
constraint forall(j in 1..M) (
  Products[j] <= Demands[j]
);

% The total amount of each raw material used should not exceed its availability
constraint forall(i in 1..N) (
  sum(j in 1..M) (Requirements[i,j] * Products[j]) <= Available[i]
);

% The profit from selling each product should be greater than its production cost
constraint forall(j in 1..M) (
  (Prices[j] - Costs[j]) * Products[j] >= 0
);

% Objective
solve maximize sum(j in 1..M) ((Prices[j] - Costs[j]) * Products[j]);