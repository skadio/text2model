% Parameters
int: cost_raw = 20;        % Cost per unit of raw materials ($)
int: cost_labour = 30;     % Cost per unit of labour ($)
int: cost_machines = 10;   % Cost per unit of machines ($)

int: min_raw_plus_labour = 1000;        % Minimum combined allocation of raw materials + labour
int: max_labour_machines_diff = 500;    % Maximum allowed absolute difference between labour and machines
int: min_raw_minus_2machines = 400;     % Minimum requirement for (raw - 2*machines)

int: raw_lb = 0;      int: raw_ub = 2000;     % Bounds for raw materials allocation
int: labour_lb = 0;   int: labour_ub = 1500;  % Bounds for labour allocation
int: machines_lb = 0; int: machines_ub = 700; % Bounds for machines allocation


% Variables
var raw_lb..raw_ub: raw;                   % Allocation of raw materials (whole units)
var labour_lb..labour_ub: labour;          % Allocation of labour (whole units)
var machines_lb..machines_ub: machines;    % Allocation of machines (whole units)

% Total cost in dollars (bounded using variable upper bounds)
var 0..(cost_raw*raw_ub + cost_labour*labour_ub + cost_machines*machines_ub): total_cost;


% Constraints
% --- Total cost definition (linking variable to decision variables) ---
constraint
  total_cost = cost_raw * raw + cost_labour * labour + cost_machines * machines;

% --- Minimum combined allocation of raw materials and labour ---
constraint
  raw + labour >= min_raw_plus_labour;

% --- Balanced workflow: absolute difference between labour and machines bounded ---
constraint
  abs(labour - machines) <= max_labour_machines_diff;

% --- Project requirement: raw minus twice machines must meet minimum ---
constraint
  raw - 2 * machines >= min_raw_minus_2machines;


% Objective
solve minimize total_cost;