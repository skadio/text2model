% Parameters
int: hours_required = 500;
int: budget = 15000;

int: hours_full = 8;
int: hours_part = 4;

int: pay_full = 300;
int: pay_part = 100;

% Upper bounds (safe tight bounds from constraints)
int: ub_full = min(hours_required div hours_full, budget div pay_full);
int: ub_part = min(hours_required div hours_part, budget div pay_part);

% Variables
var 0..ub_full: n_full;
var 0..ub_part: n_part;

var 0..(ub_full + ub_part): total_workers;

% Constraints
constraint total_workers = n_full + n_part;

constraint hours_full * n_full + hours_part * n_part >= hours_required;
constraint pay_full * n_full + pay_part * n_part <= budget;

% Objective
solve minimize total_workers;