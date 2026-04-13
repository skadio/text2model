% Parameters
int: fat_apple = 2;
int: folate_apple = 5;
int: fat_carrot = 4;
int: folate_carrot = 3;

int: min_carrot = 2;
int: folate_max = 100;
int: apple_to_carrot_ratio = 3;

% Variables
var 0..(folate_max div folate_apple): apple_servings;
var min_carrot..(folate_max div folate_carrot): carrot_servings;

var 0..(fat_apple * (folate_max div folate_apple) + fat_carrot * (folate_max div folate_carrot)): total_fat;

% Constraints
constraint apple_servings = apple_to_carrot_ratio * carrot_servings;

constraint folate_apple * apple_servings + folate_carrot * carrot_servings <= folate_max;

constraint total_fat = fat_apple * apple_servings + fat_carrot * carrot_servings;

% Objective
solve maximize total_fat;