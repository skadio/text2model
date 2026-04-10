% Parameters
int: mat_avail = 300;
int: mrna_avail = 400;

int: mat_A = 30;
int: mrna_A = 50;
int: mat_B = 40;
int: mrna_B = 30;

int: treat_A = 12;
int: treat_B = 8;

int: max_A = 5;

% Variables
var 0..max_A: xA;
var 0..min(mat_avail div mat_B, mrna_avail div mrna_B): xB;

var 0..(treat_A * max_A + treat_B * (min(mat_avail div mat_B, mrna_avail div mrna_B))): total_treated;

% Constraints
constraint mat_A * xA + mat_B * xB <= mat_avail;
constraint mrna_A * xA + mrna_B * xB <= mrna_avail;

constraint xB > xA;

constraint total_treated = treat_A * xA + treat_B * xB;

% Objective
solve maximize total_treated;