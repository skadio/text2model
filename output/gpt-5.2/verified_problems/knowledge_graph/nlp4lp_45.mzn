int: D; % number of depots
int: P; % number of ports

array[1..D] of int: Numdepot; % available containers at each depot
array[1..P] of int: Numport;  % required containers at each port

float: Price; % cost per unit distance
array[1..D, 1..P] of float: Distance; % distance from depot d to port p

% x[d,p] = number of containers transported from depot d to port p
array[1..D, 1..P] of var 0..sum(Numport): x;

% Supply constraints: cannot ship more containers than available at each depot
constraint
  forall(d in 1..D) (
    sum(p in 1..P)(x[d,p]) <= Numdepot[d]
  );

% Demand constraints: each port must receive at least its requirement
constraint
  forall(p in 1..P) (
    sum(d in 1..D)(x[d,p]) >= Numport[p]
  );

% Each barge holds 2 containers; enforce shipments in multiples of 2
constraint
  forall(d in 1..D, p in 1..P) (
    x[d,p] mod 2 = 0
  );

var float: total_cost = sum(d in 1..D, p in 1..P)(Price * Distance[d,p] * int2float(x[d,p]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "x=\n"
] ++
[
  concat([ show(x[d,p]) ++ if p==P then "\n" else " " endif | p in 1..P ])
  | d in 1..D
];