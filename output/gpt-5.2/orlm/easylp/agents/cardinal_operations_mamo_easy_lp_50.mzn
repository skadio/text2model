% Parameters
int: min_total_staff = 20;              % Minimum total number of staff (doctors + nurses)
int: max_diff = 10;                     % Maximum allowed value of (2*doctors - nurses)
int: cost_doctor = 10;                  % Cost per day per doctor ($)
int: cost_nurse = 5;                    % Cost per day per nurse ($)

% Variables
var 0..min_total_staff+max_diff: doctors;   % Number of doctors (nonnegative integer, bounded)
var 0..3*min_total_staff+max_diff: nurses;  % Number of nurses (nonnegative integer, bounded)
var 0..cost_doctor*(min_total_staff+max_diff) + cost_nurse*(3*min_total_staff+max_diff): total_cost;
                                            % Total cost per day ($), bounded

% Constraints
% Staff minimum requirement: doctors + nurses must meet campaign need
constraint
  doctors + nurses >= min_total_staff;

% Campaign balance requirement: (2*doctors - nurses) cannot exceed max_diff
constraint
  2 * doctors - nurses <= max_diff;

% Total cost definition: linear combination of staff counts and per-day costs
constraint
  total_cost = cost_doctor * doctors + cost_nurse * nurses;

% Objective
solve minimize total_cost;