include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

%----------------------------
% Decision variables
% x[i,j] = units shipped from origin i to destination j
%----------------------------
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply): x;

%----------------------------
% Constraints
%----------------------------

% Do not exceed supply at each origin
constraint forall(i in 1..OriginNum) (
  sum(j in 1..DestinationNum)(x[i,j]) <= Supply[i]
);

% Meet demand exactly at each destination
constraint forall(j in 1..DestinationNum) (
  sum(i in 1..OriginNum)(x[i,j]) = Demand[j]
);

% Feasibility check (optional but helpful)
constraint sum(i in 1..OriginNum)(Supply[i]) >= sum(j in 1..DestinationNum)(Demand[j]);

%----------------------------
% Objective: minimize total transportation cost
%----------------------------
var int: total_cost =
  sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j] * x[i,j]);

solve minimize total_cost;

%----------------------------
% Output
%----------------------------
output [
  "TotalCost = ", show(total_cost), "\n",
  "Shipments x (rows=origins, cols=destinations) =\n",
  show(x), "\n"
];