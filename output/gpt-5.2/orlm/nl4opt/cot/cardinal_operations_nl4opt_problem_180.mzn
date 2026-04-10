% Parameters (with values embedded)
int: vitC_orange = 5;
int: vitA_orange = 3;
int: sugar_orange = 5;

int: vitC_grapefruit = 7;
int: vitA_grapefruit = 5;
int: sugar_grapefruit = 6;

int: req_vitC = 80;
int: req_vitA = 70;

% Upper bounds large enough to cover any optimal solution
int: max_oranges = 200;
int: max_grapefruit = 200;

% Variables
var 0..max_oranges: oranges;
var 0..max_grapefruit: grapefruit;

var 0..(sugar_orange*max_oranges + sugar_grapefruit*max_grapefruit): total_sugar;

% Constraints
constraint vitC_orange * oranges + vitC_grapefruit * grapefruit >= req_vitC;
constraint vitA_orange * oranges + vitA_grapefruit * grapefruit >= req_vitA;

% Preference: at least 2 times as many oranges as grapefruit
constraint oranges >= 2 * grapefruit;

constraint total_sugar = sugar_orange * oranges + sugar_grapefruit * grapefruit;

% Objective
solve minimize total_sugar;