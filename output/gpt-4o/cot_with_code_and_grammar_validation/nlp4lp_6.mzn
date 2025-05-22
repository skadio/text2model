% Parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

% Derived index sets
set of int: Time = 0..TotalTime;
set of int: Step = 0..TotalTime-1;

% Universal bound (can be adjusted to suit realistic limits)
int: bigM = 100000;

% Variables
array[Time] of var -bigM..bigM: x;          % position at each time
array[Time] of var -bigM..bigM: v;          % velocity at each time
array[Step] of var -bigM..bigM: a;          % acceleration (control) per step
array[Step] of var 0..bigM:    abs_a;       % |a_t| for objective

% Constraints
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

constraint
  forall(t in Step)(
    x[t+1] = x[t] + v[t]
  );

constraint
  forall(t in Step)(
    v[t+1] = v[t] + a[t]
  );

constraint
  forall(t in Step)(
    abs_a[t] >=  a[t] /\
    abs_a[t] >= -a[t]
  );

constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

% Objective
solve minimize sum(t in Step)(abs_a[t]);