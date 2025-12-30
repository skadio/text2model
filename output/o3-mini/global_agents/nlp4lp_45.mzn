include "globals.mzn";

% Data parameters (provided in the .dzn file)
int: D;                        % Number of ports
int: P;                        % Number of depots
array[1..P] of int: Numdepot;  % Number of containers available at each depot
array[1..D] of int: Numport;   % Number of containers required at each port
float: Price;                  % Cost per unit distance for transporting goods
% Distance between depot p and port d
array[1..P, 1..D] of float: Distance;  

% Decision variables:
% Let barges[p,d] be the number of barges used from depot p to port d.
% Each barge carries exactly 2 containers.
array[1..P, 1..D] of var int: barges;

% Supply constraints: A depot cannot send more containers than available.
constraint
  forall(p in 1..P) (
    2 * sum(d in 1..D)(barges[p,d]) <= Numdepot[p]
  );

% Demand constraints: Each port must receive at least its required number of containers.
constraint
  forall(d in 1..D) (
    2 * sum(p in 1..P)(barges[p,d]) >= Numport[d]
  );

% Objective: Minimize the total transportation cost.
% The cost from depot p to port d is: Price * Distance[p,d] * (2 * barges[p,d])
var float: totalCost = sum(p in 1..P, d in 1..D)( Price * Distance[p,d] * 2 * barges[p,d] );

solve minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "Shipment plan (number of containers sent via barges from each depot to each port):\n",
  concat([ "Depot " ++ show(p) ++ ": " ++ show([ 2 * barges[p,d] | d in 1..D ]) ++ "\n" | p in 1..P ])
];