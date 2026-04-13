% Parameters (with values embedded)
int: time_patch = 3;
int: mat_patch  = 5;
int: time_cream = 5;
int: mat_cream  = 6;

int: max_total_batches = 100;
int: avail_time = 400;
int: avail_mat  = 530;

int: treat_per_patch = 3;
int: treat_per_cream = 2;

% Variables
var 0..max_total_batches: patches;
var 0..max_total_batches: creams;
var 0..(treat_per_patch*max_total_batches + treat_per_cream*max_total_batches): people_treated;

% Constraints
constraint time_patch * patches + time_cream * creams <= avail_time;
constraint mat_patch  * patches + mat_cream  * creams <= avail_mat;

constraint creams >= 2 * patches;

constraint patches + creams <= max_total_batches;

constraint people_treated = treat_per_patch * patches + treat_per_cream * creams;

% Objective
solve maximize people_treated;