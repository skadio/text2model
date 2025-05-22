% Parameters
int: D; % Number of ports
int: P; % Number of depots
array[1..P] of int: Numdepot; % Number of containers available at each depot
array[1..D] of int: Numport; % Number of containers available at each port
float: Price; % Cost per unit distance for transporting goods
array[1..D, 1..P] of float: Distance; % Distance between depot d and port p

% Variables
array[1..D, 1..P] of var 0..max(Numdepot): Transport; % Number of containers transported from depot to port

% Constraints
constraint forall(d in 1..D)(sum(p in 1..P)(Transport[d,p]) = Numport[d]); % The number of containers transported to each port must equal the number of containers required at that port
constraint forall(p in 1..P)(sum(d in 1..D)(Transport[d,p]) <= Numdepot[p]); % The number of containers transported from each depot must not exceed the number of containers available at that depot

% Objective
var float: TotalCost = sum(d in 1..D, p in 1..P)(Transport[d,p] * Distance[d,p] * Price);
solve minimize TotalCost;