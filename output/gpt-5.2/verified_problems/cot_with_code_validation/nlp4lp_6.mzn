% Rocket fuel-minimization (L1 acceleration) control problem

% Parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

set of int: TIME  = 0..TotalTime;
set of int: STEPS = 0..TotalTime-1;

% Variables
array[TIME] of var int: x;
array[TIME] of var int: v;
array[STEPS] of var int: a;
array[STEPS] of var int: abs_a;

% Initial and final conditions
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

% Dynamics
constraint forall(t in STEPS) (
  x[t+1] = x[t] + v[t]
);

constraint forall(t in STEPS) (
  v[t+1] = v[t] + a[t]
);

% Absolute value modeling for |a[t]|
constraint forall(t in STEPS) (
  abs_a[t] >=  a[t] /\
  abs_a[t] >= -a[t] /\
  abs_a[t] >= 0
);

% Objective: minimize total fuel consumption
solve minimize sum(t in STEPS)(abs_a[t]);