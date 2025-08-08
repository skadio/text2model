% Wild Sports Production Optimization

% Data parameters (to be provided in a .dzn file)
int: N;                                    % Number of raw materials
int: M;                                    % Number of products
array[1..N] of int: Available;             % Available amount of each raw material i
array[1..N, 1..M] of int: Requirements;    % Amount of raw material i required per unit of product j
array[1..M] of int: Prices;                % Selling price per unit of product j
array[1..M] of int: Costs;                 % Production cost per unit of product j
array[1..M] of int: Demands;               % Maximum demand for product j

% Decision variables: production quantities for each product j.
% They must be non-negative and do not exceed the forecasted demand.
array[1..M] of var int: produce;
constraint forall(j in 1..M) (
    produce[j] >= 0 /\ produce[j] <= Demands[j]
);

% Resource constraints: for each raw material i, the total used in production (over all products)
% must not exceed the available amount.
constraint forall(i in 1..N) (
    sum(j in 1..M)( Requirements[i,j] * produce[j] ) <= Available[i]
);

% Profit is calculated as revenue minus cost.
% For each product j, profit per unit is (Prices[j] - Costs[j]).
var int: Profit = sum(j in 1..M)( (Prices[j] - Costs[j]) * produce[j] );

% Solve: maximize the overall profit.
solve maximize Profit;

% Output the production plan and the maximum achievable profit.
output [
  "Production plan: ", show(produce), "\n",
  "Profit: ", show(Profit), "\n"
];