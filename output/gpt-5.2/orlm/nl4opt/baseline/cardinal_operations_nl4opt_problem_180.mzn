% Diet optimization: oranges and grapefruit

int: vitC_orange = 5;
int: vitA_orange = 3;
int: sugar_orange = 5;

int: vitC_grapefruit = 7;
int: vitA_grapefruit = 5;
int: sugar_grapefruit = 6;

int: req_vitC = 80;
int: req_vitA = 70;

var 0..1000: oranges;
var 0..1000: grapefruit;

constraint vitC_orange * oranges + vitC_grapefruit * grapefruit >= req_vitC;
constraint vitA_orange * oranges + vitA_grapefruit * grapefruit >= req_vitA;

% Preference: at least 2 times as many oranges as grapefruit
constraint oranges >= 2 * grapefruit;

var int: total_sugar = sugar_orange * oranges + sugar_grapefruit * grapefruit;

solve minimize total_sugar;

output [
  "oranges = ", show(oranges), "\n",
  "grapefruit = ", show(grapefruit), "\n",
  "total_sugar = ", show(total_sugar), " grams\n"
];