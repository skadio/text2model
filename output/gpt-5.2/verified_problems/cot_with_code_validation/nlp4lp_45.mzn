% Parameters
int: D; % number of ports
int: P; % number of depots

array[1..P] of int: Numdepot; % containers initially available at each depot
array[1..D] of int: Numport;  % minimum containers required at each port

float: Price; % cost per unit distance
array[1..D, 1..P] of float: Distance; % distance between port d and depot p

% Decision variables
array[1..P, 1..D] of var 0..max(Numdepot): x; % containers shipped from depot p to port d
array[1..P, 1..D] of var 0..max(Numdepot): b; % barges used from depot p to port d (each holds 2 containers)

% Link containers to barges: b = ceil(x/2)
constraint
  forall(p in 1..P, d in 1..D) (
    2 * b[p,d] >= x[p,d] /\
    2 * b[p,d] <= x[p,d] + 1
  );

% Do not ship more containers than available at each depot
constraint
  forall(p in 1..P) (
    sum(d in 1..D)(x[p,d]) <= Numdepot[p]
  );

% Meet minimum required containers at each port
constraint
  forall(d in 1..D) (
    sum(p in 1..P)(x[p,d]) >= Numport[d]
  );

% Objective: minimize total transport cost (Price * distance * barges)
var float: total_cost =
  Price * sum(p in 1..P, d in 1..D)(Distance[d,p] * int2float(b[p,d]));

solve minimize total_cost;