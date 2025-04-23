% Parameters
int: X0; % Initial position of the object
int: V0; % Initial velocity of the object
int: XT; % Final position of the object
int: VT; % Final velocity of the object
int: T;  % Time duration for the journey

% Variables
array[1..T] of var int: x; % Position at each time step
array[1..T] of var int: v; % Velocity at each time step
array[1..T] of var int: a; % Acceleration at each time step
var int: thrust; % Maximum thrust required

% Constraints
% Initial conditions
constraint x[1] = X0;
constraint v[1] = V0;

% Final conditions
constraint x[T] = XT;
constraint v[T] = VT;

% Dynamics
constraint forall(t in 2..T)(
  x[t] = x[t-1] + v[t-1],
  v[t] = v[t-1] + a[t-1]
);

% Thrust
constraint forall(t in 1..T)(
  abs(a[t]) <= thrust
);

% Objective
solve minimize thrust;