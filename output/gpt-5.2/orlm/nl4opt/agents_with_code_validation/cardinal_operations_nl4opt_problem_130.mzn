% Parameters
int: items_per_machine_A = 30;          % items produced per day by one A machine
int: items_per_machine_B = 50;          % items produced per day by one B machine
int: kwh_per_machine_A   = 100;         % kWh consumed per day by one A machine
int: kwh_per_machine_B   = 120;         % kWh consumed per day by one B machine

int: min_items_per_day   = 1000;        % minimum required production per day (items)
int: max_kwh_per_day     = 3000;        % available electricity per day (kWh)

int: min_machines_A      = 5;           % at least this many A machines must be used
int: max_pct_B           = 30;          % at most 30% of machines are type B

% A safe upper bound for counts (from electricity constraint: each machine uses at least min(kWh))
int: max_machines_total_ub = max_kwh_per_day div min(kwh_per_machine_A, kwh_per_machine_B);

% Variables
var 0..max_machines_total_ub: num_machines_A;    % number of A machines used
var 0..max_machines_total_ub: num_machines_B;    % number of B machines used
var 0..2*max_machines_total_ub: total_machines;  % total number of machines (A+B)

% Constraints

% Total machines definition
constraint
  total_machines = num_machines_A + num_machines_B;

% Minimum production requirement (items/day)
constraint
  items_per_machine_A * num_machines_A
+ items_per_machine_B * num_machines_B
>= min_items_per_day;

% Electricity capacity limit (kWh/day)
constraint
  kwh_per_machine_A * num_machines_A
+ kwh_per_machine_B * num_machines_B
<= max_kwh_per_day;

% Minimum number of A machines
constraint
  num_machines_A >= min_machines_A;

% At most max_pct_B percent of machines are type B:
% 100*num_machines_B <= max_pct_B*total_machines
constraint
  100 * num_machines_B <= max_pct_B * total_machines;

% Objective
solve minimize total_machines;