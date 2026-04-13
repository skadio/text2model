% Parameters
int: protein_fish = 10;
int: iron_fish = 12;
int: fat_fish = 7;

int: protein_chicken = 15;
int: iron_chicken = 8;
int: fat_chicken = 10;

int: protein_min = 130;
int: iron_min = 120;

% Variables
var 0..1000: fish_meals;
var 0..1000: chicken_meals;

% Constraints
constraint protein_fish * fish_meals + protein_chicken * chicken_meals >= protein_min;
constraint iron_fish * fish_meals + iron_chicken * chicken_meals >= iron_min;
constraint chicken_meals >= 2 * fish_meals;

% Objective
solve minimize fat_fish * fish_meals + fat_chicken * chicken_meals;