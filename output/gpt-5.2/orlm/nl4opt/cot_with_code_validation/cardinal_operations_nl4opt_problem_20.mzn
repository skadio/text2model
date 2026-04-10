% Parameters
int: cal_ramen = 400;
int: prot_ramen = 20;
int: sod_ramen = 100;

int: cal_fries = 300;
int: prot_fries = 10;
int: sod_fries = 75;

int: min_cal = 3000;
int: min_prot = 80;

int: ramen_pct_max = 30; % percent

% Variables
var 0..1000: ramen;
var 0..1000: fries;

% Constraints
constraint cal_ramen * ramen + cal_fries * fries >= min_cal;
constraint prot_ramen * ramen + prot_fries * fries >= min_prot;

% At most 30% of meals can be ramen: ramen <= 0.30 * (ramen + fries)
% Use integer-safe linear form:
constraint 100 * ramen <= ramen_pct_max * (ramen + fries);

% Objective
solve minimize sod_ramen * ramen + sod_fries * fries;