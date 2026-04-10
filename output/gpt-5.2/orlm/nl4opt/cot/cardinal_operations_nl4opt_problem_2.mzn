% Parameters (with values embedded)
int: hours_required = 500;
int: budget = 15000;

int: hours_full = 8;
int: hours_part = 4;

int: cost_full = 300;
int: cost_part = 100;

% Upper bounds derived from requirements (cannot exceed hours requirement if all of one type)
int: max_full = hours_required div hours_full;  % 62
int: max_part = hours_required div hours_part;  % 125

% Variables
var 0..max_full: full_workers;
var 0..max_part: part_workers;

% Constraints
constraint hours_full * full_workers + hours_part * part_workers >= hours_required;
constraint cost_full * full_workers + cost_part * part_workers <= budget;

% Objective
solve minimize full_workers + part_workers;