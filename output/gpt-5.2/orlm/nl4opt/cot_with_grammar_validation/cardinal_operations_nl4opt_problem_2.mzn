% Parameters
int: hours_required = 500;
int: budget = 15000;

int: hours_full = 8;
int: hours_part = 4;

int: cost_full = 300;
int: cost_part = 100;

int: max_full = budget div cost_full;
int: max_part = budget div cost_part;

% Variables
var 0..max_full: full_workers;
var 0..max_part: part_workers;
var 0..(max_full + max_part): total_workers;

% Constraints
constraint hours_full * full_workers + hours_part * part_workers >= hours_required;
constraint cost_full * full_workers + cost_part * part_workers <= budget;

constraint total_workers = full_workers + part_workers;

% Objective
solve minimize total_workers;