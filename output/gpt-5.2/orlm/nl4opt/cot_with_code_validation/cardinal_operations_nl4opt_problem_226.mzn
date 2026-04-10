% Parameters
int: cal_salmon = 300;
int: prot_salmon = 15;
int: sod_salmon = 80;

int: cal_eggs = 200;
int: prot_eggs = 8;
int: sod_eggs = 20;

int: min_cal = 2000;
int: min_prot = 90;

% at most 40% of meals can be eggs: eggs <= 0.4*(salmon+eggs) -> 3*eggs <= 2*salmon
int: egg_ratio_num = 3;
int: egg_ratio_den = 2;

% Variables
var 0..1000: salmon;
var 0..1000: eggs;

var 0..1000000: total_sodium;

% Constraints
constraint cal_salmon * salmon + cal_eggs * eggs >= min_cal;
constraint prot_salmon * salmon + prot_eggs * eggs >= min_prot;

constraint egg_ratio_num * eggs <= egg_ratio_den * salmon;

constraint total_sodium = sod_salmon * salmon + sod_eggs * eggs;

% Objective
solve minimize total_sodium;