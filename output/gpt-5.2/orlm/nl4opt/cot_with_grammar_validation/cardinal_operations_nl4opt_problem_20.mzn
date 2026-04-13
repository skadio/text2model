% Parameters
int: cal_ramen = 400;
int: prot_ramen = 20;
int: sod_ramen = 100;

int: cal_fries = 300;
int: prot_fries = 10;
int: sod_fries = 75;

int: min_cal = 3000;
int: min_prot = 80;

% Variables
var 0..1000: ramen;
var 0..1000: fries;

% Constraints
constraint cal_ramen * ramen + cal_fries * fries >= min_cal;
constraint prot_ramen * ramen + prot_fries * fries >= min_prot;

% At most 30% of meals can be ramen: ramen <= 0.3*(ramen+fries)
% Use integer form to avoid floats: 10*ramen <= 3*(ramen+fries) => 7*ramen <= 3*fries
constraint 7 * ramen <= 3 * fries;

% Objective
solve minimize (sod_ramen * ramen + sod_fries * fries);