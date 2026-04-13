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
var 0..1000: almonds;
var 0..1000: cashews;

var 0..(fat_alm*1000 + fat_cas*1000): total_fat;

% Constraints
constraint cal_alm * almonds + cal_cas * cashews >= min_cal;
constraint prot_alm * almonds + prot_cas * cashews >= min_prot;
constraint almonds >= 2 * cashews;

constraint total_fat = fat_alm * almonds + fat_cas * cashews;

% Objective
solve minimize total_fat;