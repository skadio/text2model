% Parameters (with values embedded)
int: calories_almonds = 200;
int: protein_almonds  = 20;
int: fat_almonds      = 15;

int: calories_cashews = 300;
int: protein_cashews  = 25;
int: fat_cashews      = 12;

int: min_calories = 10000;
int: min_protein  = 800;

% Variables
var 0..1000: almonds_servings;
var 0..1000: cashews_servings;

% Constraints
constraint calories_almonds * almonds_servings + calories_cashews * cashews_servings >= min_calories;
constraint protein_almonds  * almonds_servings + protein_cashews  * cashews_servings >= min_protein;

% at least twice as many servings of almonds as cashews
constraint almonds_servings >= 2 * cashews_servings;

% Objective
var 0..100000: total_fat;
constraint total_fat = fat_almonds * almonds_servings + fat_cashews * cashews_servings;

solve minimize total_fat;