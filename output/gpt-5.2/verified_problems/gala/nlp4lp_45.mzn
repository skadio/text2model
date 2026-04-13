include "globals.mzn";

%-----------------------------
% Input data
%-----------------------------
int: D;                              % number of ports
int: P;                              % number of depots

array[1..P] of int: Numdepot;        % containers currently at each depot
array[1..D] of int: Numport;         % containers required at each port (demand)

float: Price;                        % cost per unit distance
array[1..D, 1..P] of float: Distance;% distance from depot p to port d

%-----------------------------
% Decision variables
%-----------------------------
% x[d,p] = number of containers shipped from depot p to port d
array[1..D, 1..P] of var 0..sum(Numdepot): x;

% Each barge holds 2 containers, so barges[d,p] = ceil(x[d,p]/2)
array[1..D, 1..P] of var 0..sum(Numdepot): barges;

%-----------------------------
% Constraints
%-----------------------------
% Depot capacity: cannot ship more than available at each depot
constraint forall(p in 1..P) (
  sum(d in 1..D)(x[d,p]) <= Numdepot[p]
);

% Port demand: must receive at least required containers
constraint forall(d in 1..D) (
  sum(p in 1..P)(x[d,p]) >= Numport[d]
);

% Barge capacity (2 containers per barge): barges = ceil(x/2)
constraint forall(d in 1..D, p in 1..P) (
  2 * barges[d,p] >= x[d,p] /\
  2 * (barges[d,p] - 1) < x[d,p]  % enforces minimal barges for positive x
);

% Also allow x=0 implies barges=0 (already implied by the two inequalities, but keep safe)
constraint forall(d in 1..D, p in 1..P) (
  x[d,p] = 0 -> barges[d,p] = 0
);

%-----------------------------
% Objective
%-----------------------------
var float: total_cost =
  sum(d in 1..D, p in 1..P) ( Price * Distance[d,p] * (int2float(barges[d,p])) );

solve minimize total_cost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(total_cost), "\n",
  "Shipments x[d,p] (containers):\n", show(x), "\n",
  "Barges (ceil(x/2)):\n", show(barges), "\n"
];