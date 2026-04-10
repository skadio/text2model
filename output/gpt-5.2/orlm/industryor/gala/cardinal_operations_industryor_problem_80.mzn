% Parking on both sides of a street: minimize the maximum occupied length.
% Data is embedded as requested.

include "globals.mzn";

int: n = 15;
set of int: CARS = 1..n;

array[CARS] of float: lambda = [
  4.0, 4.5, 5.0, 4.1, 2.4, 5.2, 3.7, 3.5, 3.2, 4.5, 2.3, 3.3, 3.8, 4.6, 3.0
];

% If true, enforce that no side exceeds 30 meters (second question variant).
bool: limit30 = false;

% Decision: side[i] = 1 (left) or 2 (right)
array[CARS] of var 1..2: side;

% Total length on each side (in decimeters to keep integrality)
% Convert meters -> decimeters (x10) and round to nearest integer:
array[CARS] of int: L = [ round(lambda[i] * 10.0) | i in CARS ];

var 0..sum(L): leftLen;
var 0..sum(L): rightLen;

constraint leftLen  = sum(i in CARS)( L[i] * bool2int(side[i] = 1) );
constraint rightLen = sum(i in CARS)( L[i] * bool2int(side[i] = 2) );

% Objective: minimize street length occupied = max(leftLen, rightLen)
var 0..sum(L): streetLen;
constraint streetLen >= leftLen;
constraint streetLen >= rightLen;

% Optional constraint: each side <= 30 meters
int: maxSideLen = 300; % 30.0 meters = 300 decimeters
constraint if limit30 then (leftLen <= maxSideLen /\ rightLen <= maxSideLen) else true endif;

solve minimize streetLen;

output [
  "limit30 = ", show(limit30), "\n",
  "Assignment (1=left,2=right): ", show(side), "\n",
  "Left length (m)  = ", show(leftLen / 10.0), "\n",
  "Right length (m) = ", show(rightLen / 10.0), "\n",
  "Street length (m)= ", show(streetLen / 10.0), "\n"
];