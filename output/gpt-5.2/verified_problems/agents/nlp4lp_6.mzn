% Parameters
int: InitialPosition;   % x_0: initial position
int: InitialVelocity;   % v_0: initial velocity
int: FinalPosition;     % x_T: target/final position at time T
int: FinalVelocity;     % v_T: target/final velocity at time T
int: TotalTime;         % T: total number of timesteps (time increment = 1)

set of int: TIME = 0..TotalTime;        % indices for states x_t, v_t (includes 0 and T)
set of int: STEP = 0..TotalTime-1;      % indices for control a_t (0..T-1)

% Variables
array[TIME] of var int: position;        % position[t] = x_t
array[TIME] of var int: velocity;        % velocity[t] = v_t
array[STEP] of var int: acceleration;    % acceleration[t] = a_t (control input)
array[STEP] of var int: absAcceleration; % absAcceleration[t] = |a_t| (fuel proxy)

% Constraints
% Initial state constraints (x_0, v_0)
constraint position[0] = InitialPosition;
constraint velocity[0] = InitialVelocity;

% Discrete-time rocket dynamics for all timesteps t = 0..T-1
constraint forall(t in STEP) (
    position[t+1] = position[t] + velocity[t]
);
constraint forall(t in STEP) (
    velocity[t+1] = velocity[t] + acceleration[t]
);

% Final/target state constraints (x_T, v_T)
constraint position[TotalTime] = FinalPosition;
constraint velocity[TotalTime] = FinalVelocity;

% Fuel proxy: relate absAcceleration[t] to |acceleration[t]|
constraint forall(t in STEP) (
    absAcceleration[t] = abs(acceleration[t])
);

% Objective
solve minimize sum(t in STEP)(absAcceleration[t]);