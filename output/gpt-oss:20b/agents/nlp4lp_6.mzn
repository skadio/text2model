% MiniZinc model for the minimum‑fuel rocket problem

% --------------------------
% Data (to be supplied in a .dzn file)
% --------------------------
int: T;               % TotalTime
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;

% --------------------------
% Variables
% --------------------------
array[0..T]   of var float: x;          % position
array[0..T]   of var float: v;          % velocity
array[0..T-1] of var float: a;          % acceleration (control)
array[0..T-1] of var float: abs_a;      % |a[t]| (linearised)

% --------------------------
% Constraints
% --------------------------
% Initial conditions
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

% Dynamics
constraint forall(t in 0..T-1) (
    x[t+1] = x[t] + v[t] /\
    v[t+1] = v[t] + a[t]
);

% Final conditions
constraint x[T] = FinalPosition;
constraint v[T] = FinalVelocity;

% Linearisation of |a[t]|
constraint forall(t in 0..T-1) (
    abs_a[t] >= a[t] /\   % abs_a[t] >= a[t]
    abs_a[t] >= -a[t]     % abs_a[t] >= -a[t]
);

% Fuel consumption
var float: fuel = sum(t in 0..T-1)(abs_a[t]);

% --------------------------
% Objective
% --------------------------
solve minimize fuel;

% --------------------------
% Output
% --------------------------
output [
  "Fuel = ", show(fuel), "\n",
  "Acceleration sequence: ", show(a), "\n",
  "Position sequence: ", show(x), "\n",
  "Velocity sequence: ", show(v), "\n"
];