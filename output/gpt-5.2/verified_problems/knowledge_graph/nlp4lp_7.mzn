include "globals.mzn";

%--------------------------
% Parameters (provided in .dzn)
%--------------------------
float: X0;
float: V0;
float: XT;
float: VT;
int: T;

%--------------------------
% Index sets
%--------------------------
set of int: TIME = 0..T;
set of int: STEP = 0..T-1;

%--------------------------
% Decision variables
%--------------------------
array[TIME] of var float: x;
array[TIME] of var float: v;
array[STEP] of var float: a;

% Maximum thrust (fuel proxy): max_t |a_t|
var float: thrust;

%--------------------------
% Constraints
%--------------------------
constraint x[0] = X0;
constraint v[0] = V0;

constraint forall(t in STEP) (
  x[t+1] = x[t] + v[t]
);

constraint forall(t in STEP) (
  v[t+1] = v[t] + a[t]
);

constraint x[T] = XT;
constraint v[T] = VT;

% thrust >= |a[t]| for all t
constraint forall(t in STEP) (
  thrust >= abs(a[t])
);

%--------------------------
% Objective
%--------------------------
solve minimize thrust;

%--------------------------
% Output
%--------------------------
output [
  "thrust = ", show(thrust), "\n",
  "a = ", show(a), "\n",
  "x = ", show(x), "\n",
  "v = ", show(v), "\n"
];