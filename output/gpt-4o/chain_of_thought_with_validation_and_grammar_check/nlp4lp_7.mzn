% Parameters
int: T;
float: X0;
float: V0;
float: XT;
float: VT;

% Large bound for all real-valued variables
float: BIG = 1.0e6;

set of int: Time     = 0..T;
set of int: TimePrev = 0..T-1;

% Decision variables (bounded)
array[Time]     of var -BIG..BIG: x;
array[Time]     of var -BIG..BIG: v;
array[TimePrev] of var -BIG..BIG: a;
var 0.0..BIG: M;

% Initial conditions
constraint x[0] = X0;
constraint v[0] = V0;

% Dynamics
constraint forall(t in TimePrev)( x[t+1] = x[t] + v[t] );
constraint forall(t in TimePrev)( v[t+1] = v[t] + a[t] );

% Final conditions
constraint x[T] = XT;
constraint v[T] = VT;

% Relate M to the absolute accelerations
constraint forall(t in TimePrev)( abs(a[t]) <= M );

% Objective
solve minimize M;