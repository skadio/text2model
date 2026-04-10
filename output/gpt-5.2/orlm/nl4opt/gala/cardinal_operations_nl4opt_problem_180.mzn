% Diet optimization: minimize sugar while meeting vitamin requirements
include "globals.mzn";

% Data (embedded from problem statement)
int: c_orange = 5;
int: a_orange = 3;
int: s_orange = 5;

int: c_grapefruit = 7;
int: a_grapefruit = 5;
int: s_grapefruit = 6;

int: C_req = 80;
int: A_req = 70;

% Decision variables (nonnegative integers)
var 0..1000: oranges;
var 0..1000: grapefruit;

% Nutrition constraints
constraint c_orange * oranges + c_grapefruit * grapefruit >= C_req;
constraint a_orange * oranges + a_grapefruit * grapefruit >= A_req;

% Preference constraint: at least 2x as many oranges as grapefruit
constraint oranges >= 2 * grapefruit;

% Objective: minimize total sugar intake
var int: total_sugar = s_orange * oranges + s_grapefruit * grapefruit;
solve minimize total_sugar;

output [
  "oranges = ", show(oranges), "\n",
  "grapefruit = ", show(grapefruit), "\n",
  "total_sugar = ", show(total_sugar), "\n",
  "vitaminC = ", show(c_orange * oranges + c_grapefruit * grapefruit), "\n",
  "vitaminA = ", show(a_orange * oranges + a_grapefruit * grapefruit), "\n"
];