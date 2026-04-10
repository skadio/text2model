% Parameters
int: prot_alpha = 30;
int: sugar_alpha = 20;
int: cal_alpha = 350;

int: prot_omega = 20;
int: sugar_omega = 15;
int: cal_omega = 300;

int: min_protein = 100;
int: min_calories = 2000;

int: omega_pct_max_num = 35;
int: omega_pct_max_den = 100;

% Variables
var 0..100: x_alpha;
var 0..100: x_omega;
var 0..5000: total_sugar;

% Constraints
constraint prot_alpha * x_alpha + prot_omega * x_omega >= min_protein;
constraint cal_alpha * x_alpha + cal_omega * x_omega >= min_calories;

% at most 35% omega: x_omega / (x_alpha + x_omega) <= 35/100
constraint omega_pct_max_den * x_omega <= omega_pct_max_num * (x_alpha + x_omega);

constraint total_sugar = sugar_alpha * x_alpha + sugar_omega * x_omega;

% Objective
solve minimize total_sugar;