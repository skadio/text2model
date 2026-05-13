% Parameters
int: X0;
int: V0;
int: XT;
int: VT;
int: T;

% Variables
array[1..T] of var int: a;
array[0..T] of var int: x;
array[0..T] of var int: v;
var int: maxAbsA;

% Constraints
x[0] = X0;
v[0] = V0;
forall(t in 1..T) (
    x[t] = x[t-1] + v[t-1] /\
    v[t] = v[t-1] + a[t]
);
x[T] = XT;
v[T] = VT;
forall(t in 1..T) (
    maxAbsA >= abs(a[t])
);

% Objective
solve minimize maxAbsA;