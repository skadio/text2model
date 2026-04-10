% Parameters
int: time_per_patch = 3;          % minutes per medication patch batch
int: material_per_patch = 5;      % material units per medication patch batch
int: time_per_cream = 5;          % minutes per anti-biotic cream batch
int: material_per_cream = 6;      % material units per anti-biotic cream batch

int: min_cream_multiplier = 2;    % creams must be at least this multiple of patches
int: max_total_batches = 100;     % storage limit on total batches

int: available_time = 400;        % total minutes available
int: available_material = 530;    % total material units available

int: people_per_patch = 3;        % people treated per patch batch
int: people_per_cream = 2;        % people treated per cream batch

% Variables
var 0..max_total_batches: patch_batches;  % number of medication patch batches
var 0..max_total_batches: cream_batches;  % number of anti-biotic cream batches
var 0..(people_per_patch*max_total_batches + people_per_cream*max_total_batches): people_treated;

% Constraints
% Link decision variables to total people treated
constraint
  people_treated = people_per_patch * patch_batches
                 + people_per_cream * cream_batches;

% Time capacity constraint (staff minutes)
constraint
  time_per_patch * patch_batches
+ time_per_cream * cream_batches
<= available_time;

% Material capacity constraint (material units)
constraint
  material_per_patch * patch_batches
+ material_per_cream * cream_batches
<= available_material;

% Demand ratio constraint: creams must be at least a multiple of patches
constraint
  cream_batches >= min_cream_multiplier * patch_batches;

% Storage constraint: limit total batches produced
constraint
  patch_batches + cream_batches <= max_total_batches;

% Objective
solve maximize people_treated;