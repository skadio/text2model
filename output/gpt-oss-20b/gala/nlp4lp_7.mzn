include "globals.mzn";

% --- data ---------------------------------------------------------
int: X0;    % initial position
int: V0;    % initial velocity
int: XT;   % target final position
int: VT;   % target final velocity
int: T;    % time duration

% --- variables ----------------------------------------------------
array[0..T] of var int: x;          % position at each time step
array[0..T] of var int: v;          % velocity at each time step
array[1..T] of var int: a;          % acceleration chosen by the solver
var int: maxa;                       % maximum absolute acceleration

% --- constraints -------------------------------------------------
constraint x[0] = X0;
constraint v[0] = V0;

constraint forall(t in 0..T-1) (
    x[t+1] = x[t] + v[t] /\          % x_{t+1} = x_t + v_t
    v[t+1] = v[t] + a[t+1]           % v_{t+1} = v_t + a_t
);

constraint x[T] = XT;
constraint v[T] = VT;

constraint forall(t in 1..T) (
    maxa >= a[t]  /\     % maxa ≥ a_t
    maxa >= -a[t]      % maxa ≥ |a_t|
);

% --- objective ---------------------------------------------------
solve minimize maxa;

% --- output ------------------------------------------------------
output [
    "Acceleration sequence (a): ", show(a), "\n",
    "Maximum absolute acceleration (maxa): ", show(maxa), "\n",
    "\nTrajectory:\n",
    "t\tx\tv\n",
    concat([ show(t) ++ "\t" ++ show(x[t]) ++ "\t" ++ show(v[t]) ++ "\n" | t in 0..T ])
];