% Parameters
int: TotalTime;
float: InitialPosition;
float: InitialVelocity;
float: FinalPosition;
float: FinalVelocity;

% Index sets
set of int: Times = 0..TotalTime;
set of int: Steps = 0..TotalTime-1;

% A sufficiently large bound for variables
float: BIG = 1.0e6;

% Variables
array[Times] of var -BIG..BIG: x;        % Position at each time step
array[Times] of var -BIG..BIG: v;        % Velocity at each time step
array[Steps] of var -BIG..BIG: a;        % Acceleration (control) at each step
array[Steps] of var 0.0..BIG: fuel;      % |a_t|  (fuel consumption proxy)

% Constraints
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

% Discrete-time dynamics
constraint forall(t in Steps)( x[t+1] = x[t] + v[t] );
constraint forall(t in Steps)( v[t+1] = v[t] + a[t] );

% Absolute-value linearisation for fuel
constraint forall(t in Steps)( fuel[t] >=  a[t] );
constraint forall(t in Steps)( fuel[t] >= -a[t] );

% Target conditions at time T
constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

% Objective
solve minimize sum(t in Steps)( fuel[t] );