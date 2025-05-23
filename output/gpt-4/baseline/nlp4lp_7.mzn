% Parameters
int: X0; % Initial position
int: V0; % Initial velocity
int: XT; % Final position
int: VT; % Final velocity
int: T; % Time duration

% Variables
array[0..T] of var int: x; % Position at each time step
array[0..T] of var int: v; % Velocity at each time step
array[0..T] of var int: a; % Acceleration at each time step
var int: thrust; % Maximum thrust required

% Constraints
constraint x[0] = X0 /\ v[0] = V0; % Initial conditions
constraint x[T] = XT /\ v[T] = VT; % Final conditions

% Discrete-time model
constraint forall(t in 0..T-1) (
  x[t+1] = x[t] + v[t] /\ 
  v[t+1] = v[t] + a[t]
);

% Thrust is maximum absolute acceleration
constraint thrust = max(t in 0..T)(abs(a[t]));

% Objective
solve minimize thrust;

% Output
output ["Thrust: ", show(thrust), "\n"] ++
["Acceleration: "] ++ [show(a[t]) | t in 0..T];