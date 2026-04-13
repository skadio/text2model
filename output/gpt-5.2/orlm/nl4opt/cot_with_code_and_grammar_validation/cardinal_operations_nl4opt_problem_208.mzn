% Parameters
int: protein_alpha = 30;
int: sugar_alpha   = 20;
int: cal_alpha     = 350;

int: protein_omega = 20;
int: sugar_omega   = 15;
int: cal_omega     = 300;

int: min_protein = 100;
int: min_cal     = 2000;

int: max_omega_pct = 35; % percent

% Variables
var 0..1000: x_alpha; % bottles of alpha
var 0..1000: x_omega; % bottles of omega

% Constraints
constraint protein_alpha * x_alpha + protein_omega * x_omega >= min_protein;
constraint cal_alpha * x_alpha + cal_omega * x_omega >= min_cal;

% at most 35% omega: x_omega <= 0.35*(x_alpha + x_omega)
% avoid fractions: 100*x_omega <= 35*(x_alpha + x_omega)  => 65*x_omega <= 35*x_alpha
constraint 65 * x_omega <= max_omega_pct * x_alpha;

% Objective
solve minimize sugar_alpha * x_alpha + sugar_omega * x_omega;