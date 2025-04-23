include "globals.mzn";

% Parameters
int: D; % Number of ports
int: P; % Number of depots
array[1..P] of int: Numdepot; % Number of containers available at each depot
array[1..D] of int: Numport; % Number of containers required at each port
float: Price; % Cost per unit distance for transporting goods
array[1..P, 1..D] of float: Distance; % Distance between depot d and port p

% Decision variables
array[1..P, 1..D] of var 0..max(Numdepot): Transport; % Number of containers transported from depot d to port p

% Objective
var float: TotalCost = sum(d in 1..P, p in 1..D)(Transport[d,p] * Distance[d,p] * Price);

% Constraints
constraint forall(d in 1..P)(sum(p in 1..D)(Transport[d,p]) <= Numdepot[d]); % Cannot transport more containers than available at depot
constraint forall(p in 1..D)(sum(d in 1..P)(Transport[d,p]) >= Numport[p]); % Must transport at least as many containers as required at port

% Solve
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Transport: "] ++ [if fix(Transport[d,p]) > 0 then "Depot " ++ show(d) ++ " to Port " ++ show(p) ++ ": " ++ show(Transport[d,p]) ++ " containers\n" else "" endif | d in 1..P, p in 1..D];