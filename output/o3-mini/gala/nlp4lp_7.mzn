include "globals.mzn";

/* Data parameters (given in the .dzn file) */
int: T;
int: X0;
int: V0;
int: XT;
int: VT;

/*
  We assume that acceleration can be any integer within some reasonable bounds.
  This bound can be adjusted as needed. Here we use A_MAX to bound the thrust.
*/
int: A_MAX = 1000;
array[1..T] of var -A_MAX..A_MAX: a;   % acceleration at each timestep
array[0..T] of var int: x;              % position at times 0,...,T
array[0..T] of var int: v;              % velocity at times 0,...,T

/*
  f is an upper bound on the absolute acceleration used (i.e., fuel consumption)
  Our objective is to minimize f subject to f >= |a[t]| for all t=1..T.
*/
var 0..A_MAX: f;

/* Initial conditions */
constraint x[0] = X0;
constraint v[0] = V0;

/* Final conditions */
constraint x[T] = XT;
constraint v[T] = VT;

/* Dynamics of the rocket:
   For each timestep i from 1 to T:
     x[i] = x[i-1] + v[i-1]
     v[i] = v[i-1] + a[i]
*/
constraint
  forall(i in 1..T) (
    x[i] = x[i-1] + v[i-1] /\
    v[i] = v[i-1] + a[i]
  );

/* Linking the thrust variable f to the magnitude of each acceleration.
   For every timestep, f must be at least as large as the absolute acceleration.
*/
constraint
  forall(i in 1..T) (
    f >= a[i] /\ f >= -a[i]
  );

/* Objective: minimize the maximum thrust used over the journey */
solve minimize f;

output [
  "Minimum maximum acceleration = ", show(f), "\n",
  "Accelerations = ", show(a), "\n",
  "Positions = ", show(x), "\n",
  "Velocities = ", show(v), "\n"
];