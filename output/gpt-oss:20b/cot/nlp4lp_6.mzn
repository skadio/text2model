% Parameters
int: TotalTime;
float: InitialPosition;
float: InitialVelocity;
float: FinalPosition;
float: FinalVelocity;

% Variables
array[0..TotalTime-1] of var float: a;
array[0..TotalTime]   of var float: x;
array[0..TotalTime]   of var float: v;

% Constraints
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;
constraint forall(t in 0..TotalTime-1) (
    x[t+1] = x[t] + v[t] /\
    v[t+1] = v[t] + a[t]
);
constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

% Objective
solve minimize sum(t in 0..TotalTime-1)(abs(a[t]));