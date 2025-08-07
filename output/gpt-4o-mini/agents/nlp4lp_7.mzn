int: X0;  % Initial position
int: V0;  % Initial velocity
int: XT;  % Final position
int: VT;  % Final velocity
int: T;   % Time duration

% Variables
array[0..T] of var int: x;  % Position at each time step
array[0..T] of var int: v;  % Velocity at each time step
array[0..T-1] of var int: a; % Acceleration at each time step

% Initial conditions
constraint x[0] = X0;
constraint v[0] = V0;

% State transition equations
constraint forall(t in 0..T-1) (
    x[t+1] = x[t] + v[t] /\
    v[t+1] = v[t] + a[t]
);

% Final conditions
constraint x[T] = XT;
constraint v[T] = VT;

% Objective: minimize the maximum acceleration
var int: max_a;
constraint max_a = max(a);

solve minimize max_a;

output [ "Max Acceleration = ", show(max_a), "\n", 
         "Positions = ", show(x), "\n", 
         "Velocities = ", show(v), "\n", 
         "Accelerations = ", show(a), "\n" ];