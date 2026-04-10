include "globals.mzn";

% Data (embedded as required)
int: n = 10;
array[1..n] of int: a = [0,10,20,30,40,50,60,70,80,90];
array[1..n] of int: b = [60,70,80,90,100,110,120,130,140,150];

% Decision variables: landing time of each flight (integer time units)
array[1..n] of var int: land_time;
constraint forall(j in 1..n)( land_time[j] >= a[j] /\ land_time[j] <= b[j] );

% Flights must land in order 1..n
constraint increasing(land_time);

% Minimum separation between consecutive landings (to be maximized)
var 0..(max(b) - min(a)): min_sep;
constraint forall(j in 1..n-1)( land_time[j+1] - land_time[j] >= min_sep );

solve maximize min_sep;

output [
  "Maximal minimum separation (rounded to nearest time) = ", show(min_sep), "\n",
  "Landing times = ", show(land_time), "\n"
];