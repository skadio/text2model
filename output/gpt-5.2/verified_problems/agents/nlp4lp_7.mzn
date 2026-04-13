% Parameters
int: X0;              % Initial position
int: V0;              % Initial velocity
int: XT;              % Target/final position at time T
int: VT;              % Target/final velocity at time T
int: T;               % Time horizon (number of time steps)

set of int: TIME = 0..T;        % Time indices for states (includes endpoints)
set of int: STEP = 0..T-1;      % Time indices where acceleration is applied

% Variables
var int: max_abs_acc;                      % Objective variable: max_t |a_t|

array[TIME] of var int: x;                 % Position at each time t
array[TIME] of var int: v;                 % Velocity at each time t
array[STEP] of var int: a;                 % Control (acceleration) at each step t
array[STEP] of var 0..max_abs_acc: abs_a;  % Absolute value of acceleration at each step

% Constraints

% Initial state constraints (match given initial position and velocity)
constraint x[0] = X0;
constraint v[0] = V0;

% Discrete-time rocket dynamics (state update equations)
constraint forall(t in STEP) (
  x[t+1] = x[t] + v[t]
);
constraint forall(t in STEP) (
  v[t+1] = v[t] + a[t]
);

% Terminal state constraints (reach target position and velocity at time T)
constraint x[T] = XT;
constraint v[T] = VT;

% Absolute value linking constraints for each acceleration
constraint forall(t in STEP) (
  abs_a[t] >= a[t] /\
  abs_a[t] >= -a[t]
);

% Max-absolute-acceleration definition (max_abs_acc bounds all |a_t|)
constraint forall(t in STEP) (
  abs_a[t] <= max_abs_acc
);

% Objective
solve minimize max_abs_acc;