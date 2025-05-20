% Parameters
int: D; % Number of ports
int: P; % Number of depots
array[1..P] of int: Numdepot; % Number of containers available at each depot
array[1..D] of int: Numport; % Number of containers available at each port
float: Price; % Cost per unit distance for transporting goods
array[1..D, 1..P] of float: Distance; % Distance between depot d and port p

% Variables
array[1..D, 1..P] of var 0..Numdepot[P]: X; % Number of containers transported from depot p to port d

% Constraints

% Constraint 1: The number of containers transported from a depot should not exceed the number of containers available at that depot
constraint forall(p in 1..P) (
  sum(d in 1..D) (X[d, p]) <= Numdepot[p]
);

% Constraint 2: The number of containers transported to a port should meet the requirement of that port
constraint forall(d in 1..D) (
  sum(p in 1..P) (X[d, p]) >= Numport[d]
);

% Constraint 3: The number of containers transported from a depot to a port should be even, as each barge can hold two containers
constraint forall(d in 1..D, p in 1..P) (
  X[d, p] mod 2 = 0
);

% Objective
solve minimize sum(d in 1..D, p in 1..P) (X[d, p] * Distance[d, p] * Price);