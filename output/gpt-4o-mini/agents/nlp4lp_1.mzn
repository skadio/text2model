include "globals.mzn";

int: M;  % Number of different goods
int: N;  % Number of different raw materials
array[1..N] of int: Available;  % Available amount of raw materials
array[1..N, 1..M] of int: Requirements;  % Requirements of raw materials for each good
array[1..M] of int: Prices;  % Revenue from selling one unit of each good

% Decision variables: amount of each good to produce
array[1..M] of var 0..max(Available) div min(Requirements): produce;

% Constraints: ensure that the total requirements do not exceed available resources
array[1..N] of var 0..max(Available): total_requirements;
constraint forall(i in 1..N) (
    total_requirements[i] = sum(j in 1..M)(Requirements[i,j] * produce[j])
);

constraint forall(i in 1..N) (
    total_requirements[i] <= Available[i]
);

% Objective: maximize total revenue
var int: total_revenue = sum(j in 1..M)(Prices[j] * produce[j]);
solve maximize total_revenue;

% Output the results
output [
    "Produce amounts: ", show(produce), "\n",
    "Total revenue: ", show(total_revenue), "\n"
];