% Parameters (with values embedded)
int: cal_salmon = 300;
int: prot_salmon = 15;
int: sod_salmon = 80;

int: cal_eggs = 200;
int: prot_eggs = 8;
int: sod_eggs = 20;

int: min_calories = 2000;
int: min_protein = 90;

% Variables
var 0..1000: salmon_bowls;
var 0..1000: egg_bowls;

% Constraints
constraint cal_salmon * salmon_bowls + cal_eggs * egg_bowls >= min_calories;
constraint prot_salmon * salmon_bowls + prot_eggs * egg_bowls >= min_protein;

% At most 40% of meals can be eggs: egg_bowls <= 0.4*(salmon_bowls + egg_bowls)
% Multiply by 10 to keep it integer-linear: 10*egg_bowls <= 4*(salmon_bowls + egg_bowls)
constraint 10 * egg_bowls <= 4 * (salmon_bowls + egg_bowls);

% Objective
var int: total_sodium = sod_salmon * salmon_bowls + sod_eggs * egg_bowls;

solve minimize total_sodium;