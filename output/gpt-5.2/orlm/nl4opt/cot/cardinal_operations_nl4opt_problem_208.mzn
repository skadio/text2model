% Parameters (with values embedded)
int: protein_req = 100;
int: calories_req = 2000;

int: protein_alpha = 30;
int: sugar_alpha   = 20;
int: cal_alpha     = 350;

int: protein_omega = 20;
int: sugar_omega   = 15;
int: cal_omega     = 300;

% Variables
var 0..1000: alpha_bottles;
var 0..1000: omega_bottles;

% Constraints
constraint protein_alpha * alpha_bottles + protein_omega * omega_bottles >= protein_req;
constraint cal_alpha * alpha_bottles + cal_omega * omega_bottles >= calories_req;

% At most 35% of total bottles are omega:
% omega <= 0.35*(alpha+omega)  <=>  20*omega <= 7*(alpha+omega)  <=>  13*omega <= 7*alpha
constraint 13 * omega_bottles <= 7 * alpha_bottles;

% Objective
var int: total_sugar = sugar_alpha * alpha_bottles + sugar_omega * omega_bottles;
solve minimize total_sugar;