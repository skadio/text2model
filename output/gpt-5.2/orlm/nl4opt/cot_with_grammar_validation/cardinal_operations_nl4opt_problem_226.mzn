% Parameters
int: cal_salmon = 300;
int: prot_salmon = 15;
int: sod_salmon = 80;

int: cal_eggs = 200;
int: prot_eggs = 8;
int: sod_eggs = 20;

int: min_cal = 2000;
int: min_prot = 90;

% Variables
var 0..1000: salmon;
var 0..1000: eggs;

% Constraints
constraint cal_salmon * salmon + cal_eggs * eggs >= min_cal;
constraint prot_salmon * salmon + prot_eggs * eggs >= min_prot;

% At most 40% of meals are eggs: eggs / (salmon + eggs) <= 0.4
% Linearized (and avoids division): 3*eggs <= 2*salmon
constraint 3 * eggs <= 2 * salmon;

% Objective
solve minimize sod_salmon * salmon + sod_eggs * eggs;