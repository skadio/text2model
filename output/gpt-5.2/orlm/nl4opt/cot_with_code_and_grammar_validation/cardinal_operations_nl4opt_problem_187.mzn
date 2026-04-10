% Parameters
int: C_per_shot = 30;
int: D_per_shot = 40;
int: C_per_pill = 50;
int: D_per_pill = 30;

int: C_avail = 1200;
int: D_avail = 1500;

int: people_per_shot = 10;
int: people_per_pill = 7;

int: max_shots = 10;

% Variables
var 0..max_shots: shots;
var 0..min(C_avail div C_per_pill, D_avail div D_per_pill): pills;
var 0..(people_per_shot * max_shots + people_per_pill * (min(C_avail div C_per_pill, D_avail div D_per_pill))): people_supplied;

% Constraints
constraint C_per_shot * shots + C_per_pill * pills <= C_avail;
constraint D_per_shot * shots + D_per_pill * pills <= D_avail;

constraint pills > shots;

constraint people_supplied = people_per_shot * shots + people_per_pill * pills;

% Objective
solve maximize people_supplied;