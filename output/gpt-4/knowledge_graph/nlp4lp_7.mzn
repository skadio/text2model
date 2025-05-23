include "globals.mzn";

% Parameters
int: X0; % Initial position
int: V0; % Initial velocity
int: XT; % Final position
int: VT; % Final velocity
int: T;  % Time duration

% Variables
array[0..T] of var int: X; % Position at each time step
array[0..T] of var int: V; % Velocity at each time step
array[0..T] of var int: A; % Acceleration at each time step

% Constraints
constraint X[0] = X0;
constraint V[0] = V0;
constraint X[T] = XT;
constraint V[T] = VT;

constraint forall(t in 0..T-1) (
    X[t+1] = X[t] + V[t] and
    V[t+1] = V[t] + A[t]
);

% Objective
var int: maxThrust = max(t in 0..T)(abs(A[t]));
solve minimize maxThrust;

% Output
output ["Acceleration at each time step: "] ++ [show(A[t]) | t in 0..T];