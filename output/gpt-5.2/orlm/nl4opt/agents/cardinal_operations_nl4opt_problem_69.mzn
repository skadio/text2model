% Parameters
int: wide_capacity = 25;              % units per minute per wide pipe
int: narrow_capacity = 15;            % units per minute per narrow pipe
int: min_total_flow = 900;            % minimum required total water per minute
int: min_wide_pipes = 5;              % minimum number of wide pipes required

% wide <= narrow/3  =>  3*wide <= narrow
int: wide_to_narrow_ratio_num = 3;    % multiplier for wide in ratio constraint

% A safe upper bound for search:
% Using only narrow pipes: ceil(900/15) = 60, so total pipes won't need to exceed 60.
int: max_total_pipes = 60;

% Variables
var 0..max_total_pipes: wide_pipes;    % number of wide pipes used
var 0..max_total_pipes: narrow_pipes;  % number of narrow pipes used
var 0..2*max_total_pipes: total_pipes; % total number of pipes (wide + narrow)

% Constraints

% --- Total pipes definition ---
constraint
  total_pipes = wide_pipes + narrow_pipes;

% --- Minimum total water flow requirement ---
constraint
  wide_capacity * wide_pipes + narrow_capacity * narrow_pipes >= min_total_flow;

% --- Minimum number of wide pipes ---
constraint
  wide_pipes >= min_wide_pipes;

% --- Ratio / logistics constraint: wide pipes at most a third of narrow pipes ---
% wide <= narrow/3  <=>  3*wide <= narrow
constraint
  wide_to_narrow_ratio_num * wide_pipes <= narrow_pipes;

% Objective
solve minimize total_pipes;