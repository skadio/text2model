% Parameters
int: num_days = 7;                         % Number of days in the planning horizon (week)
set of int: DAYS = 1..num_days;            % Day index set

array[DAYS] of float: demand =             % Night shift demand per day
  [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];

int: consecutive_work_days = 5;            % Each nurse works 5 consecutive days
int: max_start_days = num_days;            % Possible start days (cyclic schedule)
set of int: START_DAYS = 1..max_start_days;

% Variables
array[START_DAYS] of var float: nurses_start; % Nurses starting a 5-day block on each start day (can be fractional)
var float: total_nurses;                      % Total number of nurses used (sum over start days)

% Constraints
% --- Total nurses definition ---
% Total number of nurses used equals the sum of nurses starting on each day
constraint
  total_nurses = sum(s in START_DAYS)(nurses_start[s]);

% --- Nonnegativity of start variables ---
% Cannot start a negative number of nurses
constraint
  forall(s in START_DAYS)(
    nurses_start[s] >= 0.0
  );

% --- Coverage constraints (cyclic 5-day work blocks) ---
% For each day d, nurses covering that day are those who started on any of the
% previous (consecutive_work_days-1) days including d, wrapping around the week.
constraint
  forall(d in DAYS)(
    sum(k in 0..consecutive_work_days-1)(
      nurses_start[ 1 + ((d - 1 - k + num_days) mod num_days) ]
    ) >= demand[d]
  );

% Objective
solve minimize total_nurses;