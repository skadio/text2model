% Parking on both sides of a street.
% Minimize the total occupied street length = max(total length left, total length right)
% Variant includes constraint: one side cannot exceed 30m (modeled for LEFT side).

include "globals.mzn";

int: n = 15;
set of int: CARS = 1..n;

array[CARS] of float: L = [
  4.0, 4.5, 5.0, 4.1, 2.4,
  5.2, 3.7, 3.5, 3.2, 4.5,
  2.3, 3.3, 3.8, 4.6, 3.0
];

% Scale to integer to avoid floating arithmetic issues
int: scale = 10;
array[CARS] of int: len = [ round(L[i]*scale) | i in CARS ];

% Decision: side[i] = true means car i parks on LEFT, false on RIGHT
array[CARS] of var bool: left;

var 0..sum(len): sumLeft  = sum(i in CARS)(bool2int(left[i]) * len[i]);
var 0..sum(len): sumRight = sum(i in CARS)((1 - bool2int(left[i])) * len[i]);

% Objective: total street length occupied (the longer side determines needed length)
var 0..sum(len): streetLen;
constraint streetLen >= sumLeft;
constraint streetLen >= sumRight;

% ---- Variant constraint: cars on one side cannot exceed 30 meters ----
int: capLeft = 30 * scale;     % 30m
constraint sumLeft <= capLeft; % change to sumRight <= capLeft if the other side is capped

solve minimize streetLen;

output [
  "Objective street length (m): ", show(streetLen/scale), "\n",
  "Left total (m):  ", show(sumLeft/scale), "\n",
  "Right total (m): ", show(sumRight/scale), "\n\n",
  "Cars on LEFT:  ", show([i | i in CARS where fix(left[i]) = true]), "\n",
  "Cars on RIGHT: ", show([i | i in CARS where fix(left[i]) = false]), "\n"
];