int: InitialPosition;   % Initial position of the rocket
int: InitialVelocity;   % Initial velocity of the rocket
int: FinalPosition;     % Target final position of the rocket
int: FinalVelocity;     % Target final velocity of the rocket
int: TotalTime;         % Total time of the rocket's movement

% Variables
array[0..TotalTime-1] of var int: a;  % Acceleration at each timestep
array[0..TotalTime] of var int: x;     % Position at each timestep
array[0..TotalTime] of var int: v;     % Velocity at each timestep

% Initial conditions
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

% State transition equations
constraint forall(t in 0..TotalTime-2) (
    x[t+1] = x[t] + v[t]  % Position update
    /\ v[t+1] = v[t] + a[t]  % Velocity update
);

% Final conditions
constraint x[TotalTime] = FinalPosition;  % Final position constraint
constraint v[TotalTime] = FinalVelocity;  % Final velocity constraint

% Objective: Minimize total fuel consumption
var int: totalFuel = sum(t in 0..TotalTime-1)(abs(a[t]));
solve minimize totalFuel;

% Output
output [
    "Accelerations = ", show(a), "\n",
    "Positions = ", show(x), "\n",
    "Velocities = ", show(v), "\n",
    "Total Fuel Consumption = ", show(totalFuel), "\n"
];