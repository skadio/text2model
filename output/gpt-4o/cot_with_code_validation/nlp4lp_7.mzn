int: T;                       % Time duration (number of discrete steps)
float: X0;                    % Initial position
float: V0;                    % Initial velocity
float: XT;                    % Target position
float: VT;                    % Target velocity

set of int: TIME = 0..T;      % Instants 0 … T
set of int: STEP = 0..T-1;    % Intervals 0 … T-1

array[TIME] of var float: x;  % Position at each instant
array[TIME] of var float: v;  % Velocity at each instant
array[STEP] of var float: a;  % Control accelerations
var float: M;                 % Maximum absolute acceleration

constraint x[0] = X0;
constraint v[0] = V0;
constraint x[T] = XT;
constraint v[T] = VT;

constraint forall(t in STEP)(x[t+1] = x[t] + v[t]);
constraint forall(t in STEP)(v[t+1] = v[t] + a[t]);
constraint forall(t in STEP)(abs(a[t]) <= M);

constraint M >= 0.0;

solve minimize M;