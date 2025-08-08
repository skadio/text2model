% Rocket optimal control using discrete-time dynamics
%
% Data input (provided via .dzn file):
%   int: InitialPosition;
%   int: InitialVelocity;
%   int: FinalPosition;
%   int: FinalVelocity;
%   int: TotalTime;        % Total number of time units for the maneuver

% Example data (for testing purposes):
% InitialPosition = 0;
% InitialVelocity = 0;
% FinalPosition = 1;
% FinalVelocity = 0;
% TotalTime = 20;

% Variables for state and control
array[0..TotalTime] of var int: x;          % Position at each time step
array[0..TotalTime] of var int: v;          % Velocity at each time step
array[0..TotalTime-1] of var int: a;         % Acceleration (control) for time 0..TotalTime-1

% Initial conditions
constraint x[0] = InitialPosition;
constraint v[0] = InitialVelocity;

% Dynamics constraints
constraint forall(t in 0..TotalTime-1) (
    x[t+1] = x[t] + v[t]  /\  v[t+1] = v[t] + a[t]
);

% Final constraints
constraint x[TotalTime] = FinalPosition;
constraint v[TotalTime] = FinalVelocity;

% Define objective: minimize total fuel consumption.
% Here fuel consumption is proportional to the sum of the absolute values of acceleration.
var int: TotalFuel = sum(t in 0..TotalTime-1)( abs(a[t]) );

solve minimize TotalFuel;

output [
    "Total Fuel = ", show(TotalFuel), "\n",
    "Accelerations: ", show(a), "\n",
    "Positions: ", show(x), "\n",
    "Velocities: ", show(v), "\n"
];