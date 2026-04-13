% Parameters
int: X0;                 % Initial position x_0
int: V0;                 % Initial velocity v_0
int: XT;                 % Target/final position x_T
int: VT;                 % Target/final velocity v_T
int: T;                  % Time horizon (number of steps), T >= 1

set of int: Time  = 0..T;        % State indices
set of int: Steps = 0..T-1;      % Control indices

% Decision variables
array[Time]  of var int: x;      % Position
array[Time]  of var int: v;      % Velocity
array[Steps] of var int: a;      % Acceleration

% Objective variable
var 0..int_max: max_abs_a;

% Constraints

% Initial conditions
constraint x[0] = X0;
constraint v[0] = V0;

% Dynamics (unit time step)
constraint forall(t in Steps) (
  x[t+1] = x[t] + v[t] /\
  v[t+1] = v[t] + a[t]
);

% Terminal conditions
constraint x[T] = XT;
constraint v[T] = VT;

% Define max_abs_a = max_t |a_t|
constraint forall(t in Steps) (
  max_abs_a >= abs(a[t])
);

% Tighten max_abs_a (helps solving)
constraint exists(t in Steps) (max_abs_a = abs(a[t]));

solve minimize max_abs_a;