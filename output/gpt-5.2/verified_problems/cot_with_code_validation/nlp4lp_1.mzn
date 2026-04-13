% Parameters
int: M; % number of goods
int: N; % number of raw materials

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;

% Variables
array[1..M] of var 0..int_max: Produce;
var int: TotalRevenue;

% Constraints
constraint forall(i in 1..N) (
  sum(j in 1..M)(Requirements[i,j] * Produce[j]) <= Available[i]
);

constraint TotalRevenue = sum(j in 1..M)(Prices[j] * Produce[j]);

% Objective
solve maximize TotalRevenue;

output [
  "Produce = ", show(Produce), "\n",
  "TotalRevenue = ", show(TotalRevenue), "\n"
];