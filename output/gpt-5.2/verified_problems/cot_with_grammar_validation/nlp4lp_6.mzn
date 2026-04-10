% Parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

set of int: TIME = 0..TotalTime;
set of int: STEP = 0..TotalTime-1;

% Variables
array[TIME] of var int: x;
array[TIME] of var int: v;
array[STEP] of var int: a;
array[STEP] of var int: abs_a;

% Constraints
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

constraint forall(t in STEP) (
  x[t+1] = x[t] + v[t]
);

constraint forall(t in STEP) (
  v[t+1] = v[t] + a[t]
);

constraint forall(t in STEP) (
  abs_a[t] >= a[t] /\ abs_a[t] >= -a[t] /\ abs_a[t] >= 0
);

% Objective
solve minimize sum(t in STEP)(abs_a[t]);