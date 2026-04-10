% Parameters
int: hours_required = 500;
int: budget = 15000;

int: hours_full = 8;
int: hours_part = 4;

int: pay_full = 300;
int: pay_part = 100;

% Variables
var 0..(hours_required div hours_part): full_workers;
var 0..(hours_required div hours_part): part_workers;
var 0..(2 * (hours_required div hours_part)): total_workers;

% Constraints
constraint hours_full * full_workers + hours_part * part_workers >= hours_required;
constraint pay_full * full_workers + pay_part * part_workers <= budget;
constraint total_workers = full_workers + part_workers;

% Objective
solve minimize total_workers;