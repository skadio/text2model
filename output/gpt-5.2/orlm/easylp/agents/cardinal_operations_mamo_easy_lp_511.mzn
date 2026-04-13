% Parameters
int: cost_raw_materials = 20;      % $ per unit of raw materials
int: cost_labour        = 30;      % $ per unit of labour
int: cost_machines      = 10;      % $ per unit of machines

int: min_raw_plus_labour       = 1000; % minimum total units of raw materials + labour
int: max_labour_machine_diff   = 500;  % maximum allowed |labour - machines|
int: min_raw_minus_2machines   = 400;  % minimum required raw materials - 2*machines

int: raw_min = 0;  int: raw_max = 2000; % bounds for raw materials allocation
int: lab_min = 0;  int: lab_max = 1500; % bounds for labour allocation
int: mac_min = 0;  int: mac_max = 700;  % bounds for machines allocation

% Variables
var raw_min..raw_max: raw_materials;  % allocation units for raw materials (integer)
var lab_min..lab_max: labour;         % allocation units for labour (integer)
var mac_min..mac_max: machines;       % allocation units for machines (integer)

var int: total_cost;                  % total cost in dollars (integer)

% Constraints
% Link decision variables to total_cost
constraint
  total_cost =
    cost_raw_materials * raw_materials +
    cost_labour        * labour +
    cost_machines      * machines;

% Minimum production requirement
constraint raw_materials + labour >= min_raw_plus_labour;

% Balanced workflow requirement
constraint abs(labour - machines) <= max_labour_machine_diff;

% Project-specific requirement
constraint raw_materials - 2 * machines >= min_raw_minus_2machines;

% Objective
solve minimize total_cost;