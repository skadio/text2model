% Parameters
int: cal_almonds = 200;
int: prot_almonds = 20;
int: fat_almonds = 15;

int: cal_cashews = 300;
int: prot_cashews = 25;
int: fat_cashews = 12;

int: min_calories = 10000;
int: min_protein = 800;

% Variables
var 0..100000: a; % servings of almonds
var 0..100000: c; % servings of cashews

var 0..100000000: total_fat;

% Constraints
constraint cal_almonds * a + cal_cashews * c >= min_calories;
constraint prot_almonds * a + prot_cashews * c >= min_protein;

constraint a >= 2 * c;

constraint total_fat = fat_almonds * a + fat_cashews * c;

% Objective
solve minimize total_fat;