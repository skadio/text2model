% Parameters
int: steel_per_chop_saw = 25;          % pounds of steel cut per chop saw per day
int: waste_per_chop_saw = 25;          % waste units produced per chop saw per day
int: steel_per_steel_cutter = 5;       % pounds of steel cut per steel cutter per day
int: waste_per_steel_cutter = 3;       % waste units produced per steel cutter per day

int: required_steel = 520;             % required pounds of steel to cut per day
int: max_waste = 400;                  % maximum allowed waste units per day

% Variables
% Upper bounds chosen large enough to allow feasibility while keeping domains finite.
var 0..(required_steel div steel_per_chop_saw + 1 + required_steel div steel_per_steel_cutter + 1): n_chop_saws;
var 0..(required_steel div steel_per_steel_cutter + 1): n_steel_cutters;

var 0..(required_steel div min(steel_per_chop_saw, steel_per_steel_cutter) + 1): total_machines;

% Constraints
% Steel production requirement: total steel cut must meet or exceed daily demand
constraint
  steel_per_chop_saw * n_chop_saws + steel_per_steel_cutter * n_steel_cutters
  >= required_steel;

% Waste limitation: total waste produced must not exceed the daily maximum
constraint
  waste_per_chop_saw * n_chop_saws + waste_per_steel_cutter * n_steel_cutters
  <= max_waste;

% Total machines definition: link total_machines to the sum of purchased equipment
constraint
  total_machines = n_chop_saws + n_steel_cutters;

% Objective
solve minimize total_machines;