% Parameters
int: N;                                 % Number of raw materials
int: M;                                 % Number of products

array[1..N] of int: Available;          % Available amount of raw material i
array[1..N, 1..M] of int: Requirements; % Units of raw material i needed per unit of product j

array[1..M] of int: Prices;             % Selling price per unit of product j
array[1..M] of int: Costs;              % Production cost per unit of product j
array[1..M] of int: Demands;            % Maximum demand (upper bound) for product j


% Variables
array[1..M] of var 0..max(Demands): Produce;  % Units of product j to produce (bounded by max demand)
var int: Profit;                               % Total profit (revenue - cost)


% Constraints

%--- Demand / production upper bounds (kept explicit for clarity) ---
constraint
  forall(j in 1..M) (
    Produce[j] <= Demands[j]
  );

%--- Raw material availability: total usage of each material cannot exceed available stock ---
constraint
  forall(i in 1..N) (
    sum(j in 1..M) (Requirements[i, j] * Produce[j]) <= Available[i]
  );

%--- Profit definition: total revenue minus total production cost ---
constraint
  Profit = sum(j in 1..M) ((Prices[j] - Costs[j]) * Produce[j]);


% Objective
solve maximize Profit;