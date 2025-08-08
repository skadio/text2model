% =======================
%  MiniZinc model for the
%  Wild Sports production problem
% =======================

% ----- Data -----
int: N;                                 % number of raw materials
int: M;                                 % number of products

array[1..N] of int: Available;          % available amount of each raw material
array[1..N, 1..M] of int: Requirements; % amount of each material needed per unit of product
array[1..M] of int: Prices;              % selling price of each product
array[1..M] of int: Costs;               % production cost of each product
array[1..M] of int: Demands;             % maximum demand for each product

% ----- Decision variables -----
array[1..M] of var 0..Demands[i]: prod;  % quantity to produce for each product

% ----- Constraints -----
% Material usage must not exceed availability
constraint
  forall(i in 1..N) (
    sum(j in 1..M) Requirements[i][j] * prod[j] <= Available[i]
  );

% ----- Objective -----
var int: profit = sum(j in 1..M) (Prices[j] - Costs[j]) * prod[j];

solve maximize profit;

% ----- Output -----
output [
  "Production plan: ", show(prod), "\n",
  "Total profit:    ", show(profit), "\n"
];