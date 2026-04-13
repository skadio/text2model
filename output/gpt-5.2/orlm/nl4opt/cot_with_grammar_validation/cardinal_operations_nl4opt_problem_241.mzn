% Parameters
int: time_patch = 3;
int: mat_patch = 5;
int: time_cream = 5;
int: mat_cream = 6;

int: min_cream_per_patch = 2;

int: max_total_batches = 100;
int: max_time = 400;
int: max_materials = 530;

int: treat_patch = 3;
int: treat_cream = 2;

int: max_patches = max_total_batches;
int: max_creams = max_total_batches;

% Variables
var 0..max_patches: patches;
var 0..max_creams: creams;

var 0..(treat_patch * max_patches + treat_cream * max_creams): treated;

% Constraints
constraint
  creams >= min_cream_per_patch * patches;

constraint
  patches + creams <= max_total_batches;

constraint
  time_patch * patches + time_cream * creams <= max_time;

constraint
  mat_patch * patches + mat_cream * creams <= max_materials;

constraint
  treated = treat_patch * patches + treat_cream * creams;

% Objective
solve maximize treated;