include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

% Time indices: states at t=0..T, controls at t=0..T-1
int: T = TotalTime;
set of int: TS = 0..T;
set of int: TC = 0..T-1;

%----------------------------
% Decision variables
%----------------------------
% Positions, velocities, accelerations (integer-valued discrete model)
array[TS] of var int: x;
array[TS] of var int: v;
array[TC] of var int: a;

% Absolute accelerations and total fuel
array[TC] of var 0..int_max: abs_a;
var 0..int_max: fuel;

%----------------------------
% Constraints
%----------------------------
% Initial conditions
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

% Dynamics (dt = 1)
constraint forall(t in TC) (
  x[t+1] = x[t] + v[t] /\
  v[t+1] = v[t] + a[t]
);

% Target conditions at time T
constraint x[T] = FinalPosition;
constraint v[T] = FinalVelocity;

% Absolute value linearization
constraint forall(t in TC) (
  abs_a[t] >=  a[t] /\
  abs_a[t] >= -a[t]
);

% Fuel consumption objective
constraint fuel = sum(t in TC)(abs_a[t]);

%----------------------------
% Solve
%----------------------------
solve minimize fuel;

%----------------------------
% Output
%----------------------------
output [
  "fuel = ", show(fuel), "\n",
  "a = ", show([a[t] | t in TC]), "\n",
  "x = ", show([x[t] | t in TS]), "\n",
  "v = ", show([v[t] | t in TS]), "\n"
];