include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: N;                                 % number of raw materials
int: M;                                 % number of products
array[1..N] of int: Available;          % available amount of each raw material
array[1..N, 1..M] of int: Requirements; % material i needed per unit of product j
array[1..M] of int: Prices;             % selling price per unit of product j
array[1..M] of int: Costs;              % production cost per unit of product j
array[1..M] of int: Demands;            % max demand per product

%----------------------------
% Decision variables
%----------------------------
array[1..M] of var 0..max(Demands): x;   % units to produce (and sell) for each product

%----------------------------
% Constraints
%----------------------------
% Demand limits
constraint forall(j in 1..M)( x[j] <= Demands[j] );

% Raw material availability
constraint forall(i in 1..N)(
  sum(j in 1..M)( Requirements[i,j] * x[j] ) <= Available[i]
);

%----------------------------
% Objective: maximize profit
%----------------------------
array[1..M] of int: margin = [Prices[j] - Costs[j] | j in 1..M];
var int: profit = sum(j in 1..M)( margin[j] * x[j] );

solve maximize profit;

%----------------------------
% Output
%----------------------------
output [
  "Production (x) = ", show(x), "\n",
  "Profit = ", show(profit), "\n",
  "Material usage:\n"
] ++
[
  "  material " ++ show(i) ++ ": " ++
  show(sum(j in 1..M)(Requirements[i,j] * x[j])) ++ " / " ++ show(Available[i]) ++ "\n"
  | i in 1..N
];