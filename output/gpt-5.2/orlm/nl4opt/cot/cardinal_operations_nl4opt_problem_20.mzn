% Parameters (with values embedded)
int: cal_ramen = 400;
int: prot_ramen = 20;
int: sodium_ramen = 100;

int: cal_fries = 300;
int: prot_fries = 10;
int: sodium_fries = 75;

int: min_calories = 3000;
int: min_protein = 80;

% Variables
var 0..1000: ramen;
var 0..1000: fries;

% Constraints
constraint cal_ramen * ramen + cal_fries * fries >= min_calories;
constraint prot_ramen * ramen + prot_fries * fries >= min_protein;

% At most 30% of meals can be ramen: ramen / (ramen + fries) <= 0.3
% Linearized (and avoids division): 10*ramen <= 3*(ramen + fries)  -> 7*ramen <= 3*fries
constraint 7 * ramen <= 3 * fries;

% Objective
var 0..(sodium_ramen*1000 + sodium_fries*1000): total_sodium = sodium_ramen * ramen + sodium_fries * fries;
solve minimize total_sodium;