% Hospital medication patch and anti-biotic cream production optimization
% All data embedded directly in the model.

int: time_patch = 3;        % minutes per batch of medication patches
int: mat_patch  = 5;        % material units per batch of medication patches
int: treat_patch = 3;       % people treated per batch of medication patches

int: time_cream = 5;        % minutes per batch of anti-biotic creams
int: mat_cream  = 6;        % material units per batch of anti-biotic creams
int: treat_cream = 2;       % people treated per batch of anti-biotic creams

int: max_total_batches = 100;
int: max_time = 400;
int: max_materials = 530;

var 0..max_total_batches: patches;
var 0..max_total_batches: creams;

constraint patches + creams <= max_total_batches;
constraint time_patch * patches + time_cream * creams <= max_time;
constraint mat_patch * patches + mat_cream * creams <= max_materials;

% At least twice as many creams as patches
constraint creams >= 2 * patches;

var int: people_treated = treat_patch * patches + treat_cream * creams;

solve maximize people_treated;

output [
  "patches=", show(patches), "\n",
  "creams=", show(creams), "\n",
  "people_treated=", show(people_treated), "\n"
];