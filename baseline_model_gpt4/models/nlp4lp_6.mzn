% Input parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

% Decision variables
array[0..TotalTime] of var int: position; % position at each time step
array[0..TotalTime] of var int: velocity; % velocity at each time step
array[0..TotalTime-1] of var int: acceleration; % acceleration at each time step

% Objective function
var int: fuel = sum(t in 0..TotalTime-1) (abs(acceleration[t]));
minimize fuel;

% Constraints
constraint position[0] = InitialPosition;
constraint velocity[0] = InitialVelocity;
constraint position[TotalTime] = FinalPosition;
constraint velocity[TotalTime] = FinalVelocity;

% Discrete-time model constraints
constraint forall(t in 0..TotalTime-1) (
    position[t+1] = position[t] + velocity[t] /\
    velocity[t+1] = velocity[t] + acceleration[t]
);

solve satisfy;
output [ "Minimum fuel consumption: " ++ show(fuel) ++ "\n" ];