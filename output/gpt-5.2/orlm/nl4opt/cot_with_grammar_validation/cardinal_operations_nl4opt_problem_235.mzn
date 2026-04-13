% Parameters
int: n_nitrogen_A = 13;
int: n_phosphoric_A = 5;
int: n_vitA_A = 6;
int: n_vitD_A = 5;

int: n_nitrogen_B = 8;
int: n_phosphoric_B = 14;
int: n_vitA_B = 6;
int: n_vitD_B = 9;

int: min_nitrogen = 220;
int: min_phosphoric = 160;
int: max_vitA = 350;

% Upper bounds derived from vitamin A constraint: 6*(xA+xB) <= 350
int: ub_total = max_vitA div 6; % floor(350/6)=58

% Variables
var 0..ub_total: xA; % kg of fertilizer A
var 0..ub_total: xB; % kg of fertilizer B
var 0..(n_vitD_A*ub_total + n_vitD_B*ub_total): vitD_total;

% Constraints
constraint n_nitrogen_A * xA + n_nitrogen_B * xB >= min_nitrogen;
constraint n_phosphoric_A * xA + n_phosphoric_B * xB >= min_phosphoric;
constraint n_vitA_A * xA + n_vitA_B * xB <= max_vitA;

constraint vitD_total = n_vitD_A * xA + n_vitD_B * xB;

% Objective
solve minimize vitD_total;