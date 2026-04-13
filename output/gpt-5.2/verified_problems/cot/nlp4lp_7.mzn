% Parameters
int: X0;
int: V0;
int: XT;
int: VT;
int: T;

set of int: TIME = 0..T;
set of int: STEP = 0..T-1;

% Variables
array[TIME] of var int: x;
array[TIME] of var int: v;
array[STEP] of var int: a;

var int: Amax;

% Constraints
constraint T >= 1;

% Initial and terminal conditions
constraint x[0] = X0;
constraint v[0] = V0;
constraint x[T] = XT;
constraint v[T] = VT;

% Dynamics
constraint forall(t in STEP) (
  x[t+1] = x[t] + v[t]
);
constraint forall(t in STEP) (
  v[t+1] = v[t] + a[t]
);

% Max thrust bound (fuel proxy)
constraint Amax >= 0;
constraint forall(t in STEP) (
  -Amax <= a[t] /\ a[t] <= Amax
);

% Objective
solve minimize Amax;