% Parameters
int: inspect_time_washer   = 30;    % minutes of inspection per washing machine
int: fix_time_washer       = 90;    % minutes of fixing per washing machine
int: inspect_time_freezer  = 20;    % minutes of inspection per freezer
int: fix_time_freezer      = 125;   % minutes of fixing per freezer

int: inspect_minutes_available = 5000;   % total inspection minutes available
int: total_minutes_available   = 20000;  % total fixing/schedule minutes available

int: profit_washer  = 250;  % dollars earned per washing machine
int: profit_freezer = 375;  % dollars earned per freezer

% Safe upper bounds derived from time limits (keeps the search bounded)
int: max_washers  = min(inspect_minutes_available div inspect_time_washer,
                        total_minutes_available div fix_time_washer);
int: max_freezers = min(inspect_minutes_available div inspect_time_freezer,
                        total_minutes_available div fix_time_freezer);

% Variables
var 0..max_washers: num_washers;        % number of washing machines to repair
var 0..max_freezers: num_freezers;      % number of freezers to repair

% Total earnings (bounded by max possible from variable upper bounds)
var 0..(profit_washer * max_washers + profit_freezer * max_freezers): total_earnings;

% Constraints

% Link total earnings to the number of appliances repaired
constraint
  total_earnings =
    profit_washer  * num_washers +
    profit_freezer * num_freezers;

% Do not exceed total inspection minutes available
constraint
  inspect_time_washer  * num_washers +
  inspect_time_freezer * num_freezers
  <= inspect_minutes_available;

% Do not exceed total fixing/schedule minutes available
constraint
  fix_time_washer  * num_washers +
  fix_time_freezer * num_freezers
  <= total_minutes_available;

% Objective
solve maximize total_earnings;