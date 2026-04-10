% Parameters
int: wide_capacity = 25;                 % units of water per minute per wide pipe
int: narrow_capacity = 15;               % units of water per minute per narrow pipe
int: min_total_flow = 900;               % minimum required water per minute
int: min_wide_pipes = 5;                 % minimum number of wide pipes
int: wide_to_narrow_ratio_den = 3;       % 3*wide <= narrow (wide pipes at most 1/3 of narrow)

% Upper bound for search space (safe bound based on minimum pipe capacity)
int: max_pipes =
  ceil(int2float(min_total_flow) / int2float(min(wide_capacity, narrow_capacity)))
  + min_wide_pipes;

% Variables
var 0..max_pipes: wide_pipes;            % number of wide pipes used
var 0..max_pipes: narrow_pipes;          % number of narrow pipes used
var 0..2*max_pipes: total_pipes;         % total number of pipes (wide + narrow)

% Constraints

% Total pipes definition (linking variable)
constraint total_pipes = wide_pipes + narrow_pipes;

% Minimum required water flow capacity
constraint wide_capacity * wide_pipes + narrow_capacity * narrow_pipes >= min_total_flow;

% Minimum number of wide pipes
constraint wide_pipes >= min_wide_pipes;

% Logistics ratio: wide pipes can be at most one third of narrow pipes
constraint wide_to_narrow_ratio_den * wide_pipes <= narrow_pipes;

% Objective
solve minimize total_pipes;