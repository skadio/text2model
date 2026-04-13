% Parameters
int: fish_protein = 10;
int: fish_iron    = 12;
int: fish_fat     = 7;

int: chick_protein = 15;
int: chick_iron    = 8;
int: chick_fat     = 10;

int: req_protein = 130;
int: req_iron    = 120;

% Variables
var 0..1000: fish_meals;
var 0..1000: chick_meals;

% Constraints
constraint fish_protein * fish_meals + chick_protein * chick_meals >= req_protein;
constraint fish_iron    * fish_meals + chick_iron    * chick_meals >= req_iron;

constraint chick_meals >= 2 * fish_meals;

% Objective
var 0..(fish_fat*1000 + chick_fat*1000): total_fat;
constraint total_fat = fish_fat * fish_meals + chick_fat * chick_meals;

solve minimize total_fat;