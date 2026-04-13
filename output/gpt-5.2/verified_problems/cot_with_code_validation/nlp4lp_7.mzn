% Parameters
int: T;
int: X0;
int: V0;
int: XT;
int: VT;

set of int: Time = 0..T;
set of int: Steps = 0..T-1;

% Variables
array[Time] of var int: x;
array[Time] of var int: v;
array[Steps] of var int: a;

var int: M; % max_t |a_t|

% Constraints
constraint x[0] = X0;
constraint v[0] = V0;

constraint x[T] = XT;
constraint v[T] = VT;

constraint forall(t in Steps) (
  x[t+1] = x[t] + v[t] /\
  v[t+1] = v[t] + a[t]
);

% Define M = max_t |a[t]|
constraint forall(t in Steps) (
  a[t] <= M /\
  -a[t] <= M
);

constraint M >= 0;

% Objective
solve minimize M;