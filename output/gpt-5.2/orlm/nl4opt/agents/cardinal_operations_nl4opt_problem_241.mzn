% Parameters
int: time_per_patch = 3;            % minutes per medication patch batch
int: material_per_patch = 5;        % material units per medication patch batch
int: time_per_cream = 5;            % minutes per anti-biotic cream batch
int: material_per_cream = 6;        % material units per anti-biotic cream batch

int: min_cream_multiplier = 2;      % creams must be at least this multiple of patches

int: max_total_batches = 100;       % storage limit on total batches
int: max_time = 400;               % total staff minutes available
int: max_material = 530;           % total material units available

int: people_per_patch = 3;          % people treated per patch batch
int: people_per_cream = 2;          % people treated per cream batch


% Variables
var 0..max_total_batches: patches;  % number of medication patch batches to make
var 0..max_total_batches: creams;   % number of anti-biotic cream batches to make

% Total people treated (upper bound uses max_total_batches for both to keep it simple and safe)
var 0..(people_per_patch*max_total_batches + people_per_cream*max_total_batches): people_treated;


% Constraints
% Link derived variable: total people treated from chosen production quantities
constraint
  people_treated = people_per_patch * patches + people_per_cream * creams;

% Demand/popularity requirement: at least twice as many creams as patches
constraint
  creams >= min_cream_multiplier * patches;

% Storage/production limit: total batches cannot exceed capacity
constraint
  patches + creams <= max_total_batches;

% Staff time capacity constraint
constraint
  time_per_patch * patches + time_per_cream * creams <= max_time;

% Materials capacity constraint
constraint
  material_per_patch * patches + material_per_cream * creams <= max_material;


% Objective
solve maximize people_treated;