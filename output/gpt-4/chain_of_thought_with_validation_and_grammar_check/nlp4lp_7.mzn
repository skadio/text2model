% Parameters
int: X0; % Initial position of the object
int: V0; % Initial velocity of the object
int: XT; % Final position of the object
int: VT; % Final velocity of the object
int: T;  % Time duration for the journey

% Variables
var -100..100: thrust; % Maximum thrust required
array[1..T] of var -100..100: a; % Acceleration at each time step
array[1..T+1] of var -100..100: x; % Position at each time step
array[1..T+1] of var -100..100: v; % Velocity at each time step

% Constraints
% Initial conditions
constraint x[1] = X0;
constraint v[1] = V0;

% Final conditions
constraint x[T+1] = XT;
constraint v[T+1] = VT;

% Dynamics
constraint forall(t in 1..T)(
  x[t+1] = x[t] + v[t] /\ 
  v[t+1] = v[t] + a[t]
);

% Thrust constraints
constraint forall(t in 1..T)(
  a[t] <= thrust /\ 
  -a[t] <= thrust
);

% Objective
solve minimize thrust;