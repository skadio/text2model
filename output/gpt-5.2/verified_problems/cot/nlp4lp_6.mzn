% Parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

set of int: Time = 0..TotalTime;
set of int: Step = 0..TotalTime-1;

% Variables
array[Time] of var int: x;
array[Time] of var int: v;
array[Step] of var int: a;

array[Step] of var int: abs_a;

% Constraints
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

constraint forall(t in Step) (
  x[t+1] = x[t] + v[t]
);

constraint forall(t in Step) (
  v[t+1] = v[t] + a[t]
);

constraint forall(t in Step) (
  abs_a[t] >= a[t] /\ abs_a[t] >= -a[t] /\ abs_a[t] >= 0
);

% Objective
solve minimize sum(t in Step)(abs_a[t]);