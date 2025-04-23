% Parameters
int: InitialPosition; % Initial position of the object
int: InitialVelocity; % Initial velocity of the object
int: FinalPosition; % Final position of the object
int: FinalVelocity; % Final velocity of the object
int: TotalTime; % Total time over which the object is moving

% Variables
array[0..TotalTime] of var int: position; % Position of the object at each timestep
array[0..TotalTime] of var int: velocity; % Velocity of the object at each timestep
array[0..TotalTime] of var int: acceleration; % Acceleration of the object at each timestep

% Constraints

% Initial position and velocity constraints
constraint position[0] = InitialPosition;
constraint velocity[0] = InitialVelocity;

% Final position and velocity constraints
constraint position[TotalTime] = FinalPosition;
constraint velocity[TotalTime] = FinalVelocity;

% Discrete-time model constraints
constraint forall(t in 0..TotalTime-1) (
  position[t+1] = position[t] + velocity[t]
);
constraint forall(t in 0..TotalTime-1) (
  velocity[t+1] = velocity[t] + acceleration[t]
);

% Objective
solve minimize sum(t in 0..TotalTime-1) (abs(acceleration[t]));