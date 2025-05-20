% Input parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

% Variables
array[0..TotalTime] of var int: position; % Position at each time step
array[0..TotalTime] of var int: velocity; % Velocity at each time step
array[0..TotalTime-1] of var int: acceleration; % Acceleration at each time step

% Constraints
% Initial conditions
constraint position[0] = InitialPosition;
constraint velocity[0] = InitialVelocity;

% Final conditions
constraint position[TotalTime] = FinalPosition;
constraint velocity[TotalTime] = FinalVelocity;

% Dynamics
constraint forall(t in 0..TotalTime-1) (
    position[t+1] = position[t] + velocity[t] and
    velocity[t+1] = velocity[t] + acceleration[t]
);

% Objective: Minimize total fuel consumption
var int: total_fuel = sum(t in 0..TotalTime-1) (abs(acceleration[t]));
solve minimize total_fuel;

% Output
output ["Total fuel consumption: ", show(total_fuel), "\n"] ++
["Acceleration at each time step: "] ++ [show(acceleration[t]) | t in 0..TotalTime-1];