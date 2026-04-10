% Parameters
int: fat_apple = 2;
int: folate_apple = 5;
int: fat_carrot = 4;
int: folate_carrot = 3;

int: folate_max = 100;
int: carrot_min = 2;
int: apple_multiplier = 3;

% Variables
var 0..(folate_max div folate_apple): apple;
var carrot_min..(folate_max div folate_carrot): carrot;
var 0..(fat_apple * (folate_max div folate_apple) + fat_carrot * (folate_max div folate_carrot)): total_fat;

% Constraints
constraint apple = apple_multiplier * carrot;

constraint folate_apple * apple + folate_carrot * carrot <= folate_max;

constraint total_fat = fat_apple * apple + fat_carrot * carrot;

% Objective
solve maximize total_fat;