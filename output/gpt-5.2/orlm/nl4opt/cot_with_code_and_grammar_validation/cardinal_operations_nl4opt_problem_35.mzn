% Parameters
int: cal_alm = 200;
int: prot_alm = 20;
int: fat_alm = 15;

int: cal_cas = 300;
int: prot_cas = 25;
int: fat_cas = 12;

int: min_cal = 10000;
int: min_prot = 800;

% Variables
var 0..100000: alm; % servings of almonds
var 0..100000: cas; % servings of cashews

var 0..100000000: total_fat;

% Constraints
constraint 2 * cas <= alm;

constraint cal_alm * alm + cal_cas * cas >= min_cal;
constraint prot_alm * alm + prot_cas * cas >= min_prot;

constraint total_fat = fat_alm * alm + fat_cas * cas;

% Objective
solve minimize total_fat;