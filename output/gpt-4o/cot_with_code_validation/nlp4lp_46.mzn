% Parameters
int: N;                                           % Number of raw materials
int: M;                                           % Number of products

array[1..N] of int: Available;                    % Available amount of each raw material
array[1..N, 1..M] of int: Requirements;           % Material requirements per unit product
array[1..M] of int: Prices;                       % Selling price per unit product
array[1..M] of int: Costs;                        % Production cost per unit product
array[1..M] of int: Demands;                      % Maximum demand per product

int: MaxDemand = max(Demands);                    % Helper upper-bound for decision variables

% Variables
array[1..M] of var 0..MaxDemand: Production;      % Units of each product to produce

% Constraints
%
% 1. Raw material availability
constraint
    forall(i in 1..N)(
        sum(j in 1..M)(Requirements[i,j] * Production[j]) <= Available[i]
    );

% 2. Demand limits
constraint
    forall(j in 1..M)(
        Production[j] <= Demands[j]
    );

% Objective
solve maximize
    sum(j in 1..M)( (Prices[j] - Costs[j]) * Production[j] );