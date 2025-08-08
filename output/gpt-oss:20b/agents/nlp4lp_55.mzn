include "globals.mzn";

% ---------- Data ----------
int: P;                                 % number of power plants
int: C;                                 % number of cities
array[1..P] of int: Supply;             % capacity of each plant
array[1..C] of int: Demand;             % demand of each city
array[1..P, 1..C] of int: TransmissionCosts;   % cost per unit from plant p to city c

% ---------- Variables ----------
array[1..P, 1..C] of var 0..Supply[p] : x;   % amount sent from plant p to city c

% ---------- Constraints ----------
% Supply limits
constraint forall(p in 1..P) (
    sum(c in 1..C) x[p,c] <= Supply[p]
);

% Demand satisfaction (exactly)
constraint forall(c in 1..C) (
    sum(p in 1..P) x[p,c] == Demand[c]
);

% ---------- Objective ----------
var int: totalCost = sum(p in 1..P, c in 1..C) x[p,c] * TransmissionCosts[p,c];
solve minimize totalCost;

% ---------- Output ----------
output [
    "Total cost = ", show(totalCost), "\n",
    "Shipments (plant -> city):\n",
    concat([ "Plant ", show(p), ": ", show([x[p,c] | c in 1..C]), "\n"] | p in 1..P)
];