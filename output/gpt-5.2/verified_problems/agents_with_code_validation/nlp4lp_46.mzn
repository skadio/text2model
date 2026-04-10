% Parameters
int: N; % Number of different raw materials
int: M; % Number of different products

array[1..N] of int: Available; % Available amount of each raw material i
array[1..N, 1..M] of int: Requirements; % Units of raw material i required per unit of product j

array[1..M] of int: Prices;  % Selling price per unit of product j
array[1..M] of int: Costs;   % Production cost per unit of product j
array[1..M] of int: Demands; % Forecasted maximum demand for product j


% Variables
array[1..M] of var 0..max(Demands): Produce; % Units of each product to produce (bounded by max demand)
var int: Profit; % Total profit for the month


% Constraints

% Link profit to production decisions: Profit = sum_j (price_j - cost_j) * Produce_j
constraint
  Profit = sum(j in 1..M) ((Prices[j] - Costs[j]) * Produce[j]);

% Raw material availability constraints: for each material i, total usage across products <= Available[i]
constraint
  forall(i in 1..N) (
    sum(j in 1..M) (Requirements[i, j] * Produce[j]) <= Available[i]
  );

% Demand upper bounds (redundant with variable domain, kept for clarity and robustness)
constraint
  forall(j in 1..M) (
    Produce[j] <= Demands[j]
  );


% Objective
solve maximize Profit;