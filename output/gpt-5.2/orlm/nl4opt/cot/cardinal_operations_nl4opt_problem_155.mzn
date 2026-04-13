% Parameters (with values embedded)
int: fat_apple = 2;
int: folate_apple = 5;
int: fat_carrot = 4;
int: folate_carrot = 3;

int: max_folate = 100;
int: min_carrot_servings = 2;
int: apple_to_carrot_ratio = 3;

% Variables
var 0..100: apple_servings;
var 0..100: carrot_servings;
var 0..1000: total_fat;
var 0..1000: total_folate;

% Constraints
constraint apple_servings = apple_to_carrot_ratio * carrot_servings;
constraint carrot_servings >= min_carrot_servings;

constraint total_fat = fat_apple * apple_servings + fat_carrot * carrot_servings;
constraint total_folate = folate_apple * apple_servings + folate_carrot * carrot_servings;

constraint total_folate <= max_folate;

% Objective
solve maximize total_fat;