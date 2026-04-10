% Parameters
int: flowers_small = 5;
int: flowers_large = 10;

int: max_small = 80;
int: max_large = 50;

int: max_total_bouquets = 70;
int: min_large = 20;

int: small_to_large_ratio = 2;

% Variables
var 0..max_small: small_bouquets;
var 0..max_large: large_bouquets;

% Constraints
constraint small_bouquets + large_bouquets <= max_total_bouquets;
constraint large_bouquets >= min_large;
constraint small_bouquets >= small_to_large_ratio * large_bouquets;

% Objective
var 0..(flowers_small*max_small + flowers_large*max_large): total_flowers;
constraint total_flowers = flowers_small * small_bouquets + flowers_large * large_bouquets;

solve maximize total_flowers;