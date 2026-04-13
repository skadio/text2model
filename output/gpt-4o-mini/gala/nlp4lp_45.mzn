include "globals.mzn";

int: D;                          % Number of ports
int: P;                          % Number of depots
array[1..P] of int: Numdepot;   % Number of containers available at each depot
array[1..D] of int: Numport;    % Number of containers required at each port
float: Price;                   % Cost per unit distance for transporting goods
array[1..P, 1..D] of float: Distance; % Distance between depot d and port p

/* Variables */
array[1..P, 1..D] of var 0..2: transport; % Number of containers transported from depot d to port p

/* Constraints */
% Ensure that the total number of containers sent from each depot does not exceed its available containers
constraint forall(d in 1..P)(
    sum(p in 1..D)(transport[d, p]) <= Numdepot[d]
);

/* Ensure that the total number of containers received at each port meets its requirements */
constraint forall(p in 1..D)(
    sum(d in 1..P)(transport[d, p]) >= Numport[p]
);

/* Objective: Minimize the total transportation cost */
var float: total_cost = sum(d in 1..P, p in 1..D)(transport[d, p] * Distance[d, p] * Price);
solve minimize total_cost;

/* Output */
output [ "Total Transportation Cost = ", show(total_cost), "\nTransport Plan:\n" ] 
    ++ [ "Depot ", show(d), " to Port ", show(p), ": ", show(transport[d, p]), " containers\n" | d in 1..P, p in 1..D ];