% Parameters
int: D; % number of ports
int: P; % number of depots

array[1..P] of int: Numdepot; % containers currently available at each depot
array[1..D] of int: Numport;  % minimum required containers at each port

float: Price; % cost per unit distance
array[1..D, 1..P] of float: Distance; % distance between port d and depot p

% Variables
array[1..P, 1..D] of var 0..max(Numdepot): x; % containers shipped from depot p to port d
array[1..P, 1..D] of var 0..max(Numdepot): b; % barges used from depot p to port d (2 containers per barge)

var float: TotalCost;

% Constraints
constraint
  forall(p in 1..P, d in 1..D) (
    2 * b[p,d] >= x[p,d] /\
    2 * b[p,d] <  x[p,d] + 2
  );

constraint
  forall(p in 1..P) (
    sum(d in 1..D)(x[p,d]) <= Numdepot[p]
  );

constraint
  forall(d in 1..D) (
    sum(p in 1..P)(x[p,d]) >= Numport[d]
  );

constraint
  TotalCost = sum(p in 1..P, d in 1..D)( Price * Distance[d,p] * int2float(b[p,d]) );

% Objective
solve minimize TotalCost;