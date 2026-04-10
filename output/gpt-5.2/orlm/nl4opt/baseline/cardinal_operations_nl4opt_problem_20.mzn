% Diet optimization: ramen vs fries, minimize sodium

int: calories_ramen = 400;
int: protein_ramen  = 20;
int: sodium_ramen   = 100;

int: calories_fries = 300;
int: protein_fries  = 10;
int: sodium_fries   = 75;

int: min_calories = 3000;
int: min_protein  = 80;

% Decision variables: number of packs (meals)
var 0..1000: ramen;
var 0..1000: fries;

% At most 30% of meals can be ramen:
% ramen <= 0.3*(ramen+fries)  ->  10*ramen <= 3*(ramen+fries)  ->  7*ramen <= 3*fries
constraint 7 * ramen <= 3 * fries;

% Nutrition constraints
constraint calories_ramen * ramen + calories_fries * fries >= min_calories;
constraint protein_ramen  * ramen + protein_fries  * fries >= min_protein;

% Objective: minimize sodium intake
var int: total_sodium = sodium_ramen * ramen + sodium_fries * fries;
solve minimize total_sodium;

output [
  "ramen=", show(ramen), "\n",
  "fries=", show(fries), "\n",
  "total_calories=", show(calories_ramen * ramen + calories_fries * fries), "\n",
  "total_protein=", show(protein_ramen * ramen + protein_fries * fries), "\n",
  "total_sodium=", show(total_sodium), "\n"
];