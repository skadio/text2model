% Parameters
int: X0; % Initial position of the object
int: V0; % Initial velocity of the object
int: XT; % Final position of the object
int: VT; % Final velocity of the object
int: T; % Time duration for the journey

% Variables
array[1..T] of var int: x; % Position of the rocket at each time step
array[1..T] of var int: v; % Velocity of the rocket at each time step
array[1..T] of var int: a; % Acceleration of the rocket at each time step
var int: max_a; % Maximum acceleration (thrust) required

% Constraints

% Initial position and velocity constraints
constraint x[1] = X0;
constraint v[1] = V0;

% Final position and velocity constraints
constraint x[T] = XT;
constraint v[T] = VT;

% Discrete-time model constraints
constraint forall(t in 1..T-1) (
  x[t+1] = x[t] + v[t] % Position update
);
constraint forall(t in 1..T-1) (
  v[t+1] = v[t] + a[t] % Velocity update
);

% Maximum acceleration (thrust) constraint
constraint forall(t in 1..T) (
  abs(a[t]) <= max_a
);

% Objective
solve minimize max_a;