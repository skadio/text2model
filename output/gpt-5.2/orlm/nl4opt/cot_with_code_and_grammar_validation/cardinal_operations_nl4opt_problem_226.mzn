% Parameters
int: cal_salmon = 300;
int: prot_salmon = 15;
int: sod_salmon = 80;

int: cal_eggs = 200;
int: prot_eggs = 8;
int: sod_eggs = 20;

int: min_cal = 2000;
int: min_prot = 90;

int: max_eggs_pct_num = 40;   % eggs <= 40% of total meals
int: max_eggs_pct_den = 100;

% Variables
var 0..10000: salmon;
var 0..10000: eggs;

% Constraints
constraint
  cal_salmon * salmon + cal_eggs * eggs >= min_cal;

constraint
  prot_salmon * salmon + prot_eggs * eggs >= min_prot;

% eggs <= 0.40 * (salmon + eggs)  <=>  100*eggs <= 40*(salmon+eggs)
constraint
  max_eggs_pct_den * eggs <= max_eggs_pct_num * (salmon + eggs);

% Objective
solve minimize sod_salmon * salmon + sod_eggs * eggs;