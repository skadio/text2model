% Parameters
int: fat_apple = 2;
int: folate_apple = 5;
int: fat_carrot = 4;
int: folate_carrot = 3;

int: min_carrot = 2;
int: max_folate = 100;
int: apple_per_carrot = 3;

% Variables
var 0..(max_folate div folate_apple): apple;
var min_carrot..(max_folate div folate_carrot): carrot;
var 0..(fat_apple * (max_folate div folate_apple) + fat_carrot * (max_folate div folate_carrot)): total_fat;

% Constraints
constraint apple = apple_per_carrot * carrot;

constraint folate_apple * apple + folate_carrot * carrot <= max_folate;

constraint total_fat = fat_apple * apple + fat_carrot * carrot;

% Objective
solve maximize total_fat;