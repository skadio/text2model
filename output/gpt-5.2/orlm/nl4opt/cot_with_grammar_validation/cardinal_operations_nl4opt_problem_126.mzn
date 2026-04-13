% Parameters
int: flowers_small = 5;
int: flowers_large = 10;

int: max_small = 80;
int: max_large = 50;
int: max_total_bouquets = 70;

int: min_large = 20;

% Variables
var 0..max_small: small;
var 0..max_large: large;
var 0..(flowers_small*max_small + flowers_large*max_large): total_flowers;

% Constraints
constraint small + large <= max_total_bouquets;
constraint large >= min_large;

constraint small >= 2 * large;

constraint total_flowers = flowers_small * small + flowers_large * large;

% Objective
solve maximize total_flowers;