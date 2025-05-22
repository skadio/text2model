% Parameters
int: T;                       % Time horizon (number of discrete steps)
float: X0;                    % Initial position
float: V0;                    % Initial velocity
float: XT;                    % Target position at time T
float: VT;                    % Target velocity at time T

set of int: TS       = 0..T;      % Indices for states (inclusive)
set of int: TS_PREV  = 0..T-1;    % Indices for control steps (accelerations)

% Variables
array[TS]      of var float: x;   % Position at each timestep
array[TS]      of var float: v;   % Velocity at each timestep
array[TS_PREV] of var float: a;   % Acceleration (control) at each timestep
var float: max_abs_acc;           % Maximum absolute acceleration to be minimised

% Constraints
%
% Initial conditions
constraint
    x[0] = X0 /\ v[0] = V0;

% Final conditions
constraint
    x[T] = XT /\ v[T] = VT;

% Discrete-time dynamics
constraint
    forall(t in TS_PREV) (
        x[t+1] = x[t] + v[t] /\
        v[t+1] = v[t] + a[t]
    );

% Definition of maximum absolute acceleration
constraint
    max_abs_acc >= 0;

constraint
    forall(t in TS_PREV) (
        max_abs_acc >=  a[t] /\
        max_abs_acc >= -a[t]
    );

% Objective
solve minimize max_abs_acc;