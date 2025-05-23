% Input Data Nomenclature
int: D; % Number of ports
int: P; % Number of depots
array[1..P] of int: Numdepot; % Number of containers available at each depot
array[1..D] of int: Numport; % Number of containers available at each port
float: Price; % Cost per unit distance for transporting goods
array[1..D, 1..P] of float: Distance; % Distance between depot d and port p

% Variables
array[1..D, 1..P] of var 0..max(Numdepot) : X; % Number of containers transported from depot d to port p

% Constraints
constraint forall(d in 1..D)(sum(p in 1..P)(X[d,p]) = Numport[d]); % The number of containers transported to each port must equal the number of containers required at that port
constraint forall(p in 1..P)(sum(d in 1..D)(X[d,p]) <= Numdepot[p]); % The number of containers transported from each depot must not exceed the number of containers available at that depot

% Objective
var float: TotalCost = sum(d in 1..D, p in 1..P)(X[d,p]*Distance[d,p]*Price);
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++ ["Transport from depot ", show(p), " to port ", show(d), ": ", show(X[d,p]), "\n" | d in 1..D, p in 1..P];