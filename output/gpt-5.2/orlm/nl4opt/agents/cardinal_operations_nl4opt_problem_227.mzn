% Parameters
int: regular_hours_per_shift = 10;      % hours provided by one regular fire fighter
int: emergency_hours_per_shift = 6;     % hours provided by one emergency fire fighter
int: regular_cost = 300;               % cost for one regular fire fighter
int: emergency_cost = 100;             % cost for one emergency fire fighter
int: required_total_hours = 300;       % minimum required total fire fighter hours
int: budget = 7000;                    % maximum total budget available

% Useful derived bounds for decision variables
int: max_regular = budget div regular_cost;     % max regular fighters affordable
int: max_emergency = budget div emergency_cost; % max emergency fighters affordable


% Variables
var 0..max_regular: num_regular;       % number of regular fire fighters to hire
var 0..max_emergency: num_emergency;   % number of emergency fire fighters to hire


% Constraints

% Meet minimum required total fire fighter hours
constraint
  regular_hours_per_shift * num_regular
+ emergency_hours_per_shift * num_emergency
>= required_total_hours;

% Stay within the available budget
constraint
  regular_cost * num_regular
+ emergency_cost * num_emergency
<= budget;


% Objective
solve minimize num_regular + num_emergency;