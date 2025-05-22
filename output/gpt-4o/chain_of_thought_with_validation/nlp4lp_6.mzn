% Parameters
int: TotalTime;
float: InitialPosition;
float: InitialVelocity;
float: FinalPosition;
float: FinalVelocity;

% Auxiliary sets
set of int: Time       = 0..TotalTime;        % indices for states (position & velocity)
set of int: TimeAccel  = 0..TotalTime-1;      % indices for control inputs

% A generous bound for all state and control variables
float: BIG = 1.0e6;

% Variables
array[Time]      of var -BIG..BIG: pos;       % position  x_t
array[Time]      of var -BIG..BIG: vel;       % velocity  v_t
array[TimeAccel] of var -BIG..BIG: acc;       % acceleration a_t  (control)
array[TimeAccel] of var  0.0..BIG:  fuel;     % |a_t|, linearised absolute value

% Constraints
%
% Initial conditions
constraint pos[0] = InitialPosition;
constraint vel[0] = InitialVelocity;

% Dynamics
constraint
  forall(t in TimeAccel)(
       pos[t+1] = pos[t] + vel[t] /\
       vel[t+1] = vel[t] + acc[t]
  );

% Final (target) conditions
constraint pos[TotalTime] = FinalPosition;
constraint vel[TotalTime] = FinalVelocity;

% Absolute-value linearisation: fuel[t] = |acc[t]|
constraint
  forall(t in TimeAccel)(
       fuel[t] >=  acc[t] /\
       fuel[t] >= -acc[t]
  );

% Objective
solve minimize sum(t in TimeAccel)(fuel[t]);