% Parameters (with values embedded)
int: protein_fish = 10;
int: iron_fish    = 12;
int: fat_fish     = 7;

int: protein_chicken = 15;
int: iron_chicken    = 8;
int: fat_chicken     = 10;

int: req_protein = 130;
int: req_iron    = 120;

% Variables
var 0..1000: fish_meals;
var 0..1000: chicken_meals;
var 0..100000: total_fat;

% Constraints
constraint protein_fish * fish_meals + protein_chicken * chicken_meals >= req_protein;
constraint iron_fish    * fish_meals + iron_chicken    * chicken_meals >= req_iron;

% At least twice as many chicken meals as fish meals
constraint chicken_meals >= 2 * fish_meals;

% Define objective expression variable
constraint total_fat = fat_fish * fish_meals + fat_chicken * chicken_meals;

% Objective
solve minimize total_fat;