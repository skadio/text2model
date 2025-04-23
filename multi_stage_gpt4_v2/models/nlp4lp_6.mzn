% Parameters
int: InitialPosition; % Initial position of the object
int: InitialVelocity; % Initial velocity of the object
int: FinalPosition; % Final position of the object
int: FinalVelocity; % Final velocity of the object
int: TotalTime; % Total time over which the object is moving

% Variables
array[0..TotalTime] of var int: position; % Position of the object at each timestep
array[0..TotalTime] of var int: velocity; % Velocity of the object at each timestep
array[0..TotalTime-1] of var int: acceleration; % Acceleration of the object at each timestep

% Constraints

% Initial conditions
constraint position[0] = InitialPosition; % The initial position of the object is given
constraint velocity[0] = InitialVelocity; % The initial velocity of the object is given

% Final conditions
constraint position[TotalTime] = FinalPosition; % The final position of the object is given
constraint velocity[TotalTime] = FinalVelocity; % The final velocity of the object is given

% Discrete-time model constraints
constraint forall(t in 0..TotalTime-1) (
    position[t+1] = position[t] + velocity[t] % The position at the next timestep is the current position plus the current velocity
);
constraint forall(t in 0..TotalTime-1) (
    velocity[t+1] = velocity[t] + acceleration[t] % The velocity at the next timestep is the current velocity plus the current acceleration
);

% Objective
solve minimize sum(t in 0..TotalTime-1) (abs(acceleration[t])); % Minimize the total fuel consumption, which is proportional to the sum of the absolute values of the acceleration at each timestep