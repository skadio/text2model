int: D;
int: P;

array[1..P] of int: Numdepot;  % containers initially at each depot
array[1..D] of int: Numport;   % required minimum containers at each port
float: Price;                  % cost per unit distance
array[1..D, 1..P] of float: Distance; % distance from depot p to port d

% Decision variables:
% x[d,p] = number of containers shipped from depot p to port d
array[1..D, 1..P] of var 0..max(0, sum(Numdepot)): x;

% b[d,p] = number of barges used from depot p to port d (each carries 2 containers)
array[1..D, 1..P] of var 0..max(0, sum(Numdepot)): b;

% Link containers to barges (capacity 2 per barge)
constraint
  forall(d in 1..D, p in 1..P) (
    x[d,p] <= 2 * b[d,p] /\
    x[d,p] >= 2 * (b[d,p] - 1) + 1 -> b[d,p] > 0
  );

% Depot supply limits
constraint
  forall(p in 1..P) (
    sum(d in 1..D)(x[d,p]) <= Numdepot[p]
  );

% Port minimum requirements
constraint
  forall(d in 1..D) (
    sum(p in 1..P)(x[d,p]) >= Numport[d]
  );

% Objective: minimize total transportation cost (per barge proportional to distance)
var float: total_cost =
  Price * sum(d in 1..D, p in 1..P) ( Distance[d,p] * int2float(b[d,p]) );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "barges(b[d,p])=\n",
  concat([ concat([ show(b[d,p]) ++ if p==P then "\n" else " " endif | p in 1..P ]) | d in 1..D ]),
  "containers(x[d,p])=\n",
  concat([ concat([ show(x[d,p]) ++ if p==P then "\n" else " " endif | p in 1..P ]) | d in 1..D ])
];