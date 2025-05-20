include "globals.mzn";

% Number of different raw materials
int: N;

% Number of different products
int: M;

% Amount of raw material i available
array[1..N] of int: Available;

% Amount of raw material i required to produce one unit of product j
array[1..N, 1..M] of int: Requirements;

% Price at which product j can be sold
array[1..M] of int: Prices;

% Cost of producing one unit of product j
array[1..M] of int: Costs;

% Demand for product j
array[1..M] of int: Demands;

% Decision variable: number of each product to produce
array[1..M] of var 0..max(Demands): Produce;

% Objective: maximize profit
var int: profit = sum(j in 1..M) ((Prices[j] - Costs[j]) * Produce[j]);

% Constraint: cannot produce more than the demand
constraint forall(j in 1..M) (Produce[j] <= Demands[j]);

% Constraint: cannot use more raw materials than available
constraint forall(i in 1..N) (sum(j in 1..M) (Requirements[i,j] * Produce[j]) <= Available[i]);

% Solve
solve maximize profit;

% Output
output [ "Profit: " ++ show(profit) ++ "\n" ] ++
[ if fix(Produce[j]) > 0 then "Produce " ++ show(Produce[j]) ++ " units of product " ++ show(j) ++ "\n" else "" endif | j in 1..M ];