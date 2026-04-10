% Medication production planning (all data embedded)

% Data
int: time_patch = 3;          % minutes per batch of medication patches
int: mat_patch  = 5;          % material units per batch
int: treat_patch = 3;         % people treated per batch

int: time_cream = 5;          % minutes per batch of anti-biotic cream
int: mat_cream  = 6;          % material units per batch
int: treat_cream = 2;         % people treated per batch

int: max_batches_total = 100;
int: max_time = 400;
int: max_material = 530;

% Decision variables
var 0..max_batches_total: patches;
var 0..max_batches_total: creams;

% Constraints
constraint patches + creams <= max_batches_total;
constraint time_patch * patches + time_cream * creams <= max_time;
constraint mat_patch * patches + mat_cream * creams <= max_material;

% At least twice as many creams as patches
constraint creams >= 2 * patches;

% Objective: maximize treated people
var int: treated = treat_patch * patches + treat_cream * creams;

solve maximize treated;

output [
  "patches = ", show(patches), "\n",
  "creams  = ", show(creams), "\n",
  "treated = ", show(treated), "\n"
];