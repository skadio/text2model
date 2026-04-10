% Parameters
int: num_days = 7;                         % Number of days in the planning horizon
set of int: DAYS = 1..num_days;

array[DAYS] of float: demand =             % Night shift demand on each day
  [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

int: work_block = 5;                       % Each nurse works 5 consecutive days


% Variables
array[DAYS] of var float: start_nurses;    % start_nurses[s] = nurses starting a 5-day block on day s
var float: total_nurses;                   % Total number of nurses used (continuous for relaxed model)


% Constraints
% Link total nurses to the sum of nurses starting each 5-day block
constraint total_nurses = sum(s in DAYS)(start_nurses[s]);

% Nonnegativity of (relaxed) number of nurses starting on each day
constraint forall(s in DAYS) (start_nurses[s] >= 0.0);

% Demand coverage (cyclic): a nurse starting on day s covers days s, s+1, ..., s+work_block-1 (mod num_days)
constraint
  forall(j in DAYS) (
    sum(s in DAYS where ((j - s + num_days) mod num_days) < work_block) (start_nurses[s])
    >= demand[j]
  );


% Objective
solve minimize total_nurses;