% Parameters
int: D; % number of ports
int: P; % number of depots

array[1..P] of int: Numdepot; % containers currently available at each depot
array[1..D] of int: Numport;  % minimum containers required at each port

float: Price; % cost per unit distance
array[1..D, 1..P] of float: Distance; % distance between port d and depot p

% Variables
array[1..P, 1..D] of var 0..max(Numdepot): x; % containers shipped from depot p to port d
array[1..P, 1..D] of var 0..max(Numdepot): b; % number of barges used from depot p to port d

var float: total_cost;

% Constraints
constraint
  forall(p in 1..P) (
    sum(d in 1..D)(x[p,d]) <= Numdepot[p]
  );

constraint
  forall(d in 1..D) (
    sum(p in 1..P)(x[p,d]) >= Numport[d]
  );

% each barge holds 2 containers; b must be at least ceil(x/2)
constraint
  forall(p in 1..P, d in 1..D) (
    2*b[p,d] >= x[p,d] /\
    2*b[p,d] <= x[p,d] + 1
  );

constraint
  total_cost = Price * sum(p in 1..P, d in 1..D)(Distance[d,p] * int2float(b[p,d]));

% Objective
solve minimize total_cost;