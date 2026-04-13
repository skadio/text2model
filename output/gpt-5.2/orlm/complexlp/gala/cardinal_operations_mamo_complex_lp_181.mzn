include "globals.mzn";

% Data (embedded as required)
int: n = 10;
array[1..n] of int: a = [40, 11, 35, 38, 74, 87, 62, 75, 94, 128];
array[1..n] of int: b = [67, 87, 94, 96, 105, 137, 121, 143, 172, 151];

% Decision variables: landing times (integers)
array[1..n] of var int: land;
var int: sep; % minimum separation time to maximize

% Domains
constraint forall(j in 1..n)( land[j] >= a[j] /\ land[j] <= b[j] );

% Flights must land in the order 1..n
constraint increasing(land);

% Minimum separation definition
% (sep is <= every consecutive gap; maximizing sep makes it the minimum gap)
constraint forall(j in 1..n-1)( land[j+1] - land[j] >= sep );

% Bound sep for tighter search
constraint sep >= 0 /\ sep <= max(b) - min(a);

solve maximize sep;

output [
  "Maximal minimum separation (rounded to nearest time) = ", show(sep), "\n",
  "Landing times = ", show(land), "\n"
];