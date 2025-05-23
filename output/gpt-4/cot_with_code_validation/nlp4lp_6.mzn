% Parameters
int: InitialPosition;
int: InitialVelocity;
int: FinalPosition;
int: FinalVelocity;
int: TotalTime;

% Variables
array[0..TotalTime] of var int: position;
array[0..TotalTime] of var int: velocity;
array[0..TotalTime-1] of var -TotalTime..TotalTime: acceleration;

% Constraints
% Initial conditions
constraint position[0] = InitialPosition;
constraint velocity[0] = InitialVelocity;

% Final conditions
constraint position[TotalTime] = FinalPosition;
constraint velocity[TotalTime] = FinalVelocity;

% Dynamics
constraint forall(t in 0..TotalTime-1) (
  position[t+1] = position[t] + velocity[t] /\ 
  velocity[t+1] = velocity[t] + acceleration[t]
);

% Objective
solve minimize sum(t in 0..TotalTime-1) (abs(acceleration[t]));