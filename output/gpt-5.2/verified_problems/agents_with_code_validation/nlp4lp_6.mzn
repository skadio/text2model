% Parameters
int: InitialPosition;     % x_0 initial position
int: InitialVelocity;     % v_0 initial velocity
int: FinalPosition;       % x_T target position
int: FinalVelocity;       % v_T target velocity
int: TotalTime;           % T number of timesteps (target time)

set of int: TIME   = 0..TotalTime;      % indices for states x_t, v_t (includes T)
set of int: TIME_U = 0..TotalTime-1;    % indices for controls a_t (0..T-1)

% Variables
array[TIME] of var int: position;        % x_t position at time t
array[TIME] of var int: velocity;        % v_t velocity at time t
array[TIME_U] of var int: acceleration;  % a_t acceleration (control) at time t
array[TIME_U] of var int: abs_accel;     % |a_t| auxiliary variable for fuel use

% Constraints

% --- Initial state constraints (x_0, v_0) ---
constraint position[0] = InitialPosition;
constraint velocity[0] = InitialVelocity;

% --- Discrete-time dynamics constraints ---
% x_{t+1} = x_t + v_t
constraint forall(t in TIME_U) (
  position[t+1] = position[t] + velocity[t]
);

% v_{t+1} = v_t + a_t
constraint forall(t in TIME_U) (
  velocity[t+1] = velocity[t] + acceleration[t]
);

% --- Final/target constraints at time T (x_T, v_T) ---
constraint position[TotalTime] = FinalPosition;
constraint velocity[TotalTime] = FinalVelocity;

% --- Absolute value (fuel-use) linking constraints ---
% abs_accel[t] = |acceleration[t]|
constraint forall(t in TIME_U) (
  abs_accel[t] = abs(acceleration[t])
);

% Enforce non-negativity of abs values
constraint forall(t in TIME_U) (
  abs_accel[t] >= 0
);

% Objective
solve minimize sum(t in TIME_U)(abs_accel[t]);