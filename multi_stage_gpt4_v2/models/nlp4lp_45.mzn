% Parameters
int: D; % Number of depots
int: P; % Number of ports
array[1..D] of int: Numdepot; % Number of containers available at each depot
array[1..D] of int: Mindepot; % Minimum number of containers required at each depot
float: Price; % Cost per unit distance for transporting goods
array[1..D, 1..P] of float: Distance; % Distance between depot d and port p

% Variables
% Number of containers transported from depot d to port p
array[1..D, 1..P] of var 0..max(Numdepot) div 2: Transport;

% Constraints

% Constraint 1: The number of containers transported from each depot should not exceed the number of containers available at that depot
constraint forall(d in 1..D) (
    sum(p in 1..P) (Transport[d, p]) <= Numdepot[d] - Mindepot[d]
);

% Constraint 2: The number of containers transported from each depot to each port should be an even number (since each barge can hold two containers)
constraint forall(d in 1..D, p in 1..P) (
    Transport[d, p] mod 2 = 0
);

% Objective
solve minimize sum(d in 1..D, p in 1..P) (Transport[d, p] * Distance[d, p] * Price / 2);