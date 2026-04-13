include "globals.mzn";

% Data (embedded)
int: cal_ramen = 400;
int: prot_ramen = 20;
int: sod_ramen = 100;

int: cal_fries = 300;
int: prot_fries = 10;
int: sod_fries = 75;

int: min_cal = 3000;
int: min_prot = 80;

% Decision variables: number of packs (meals) of each
var 0..1000: ramen;
var 0..1000: fries;

% Nutrition constraints
constraint cal_ramen * ramen + cal_fries * fries >= min_cal;
constraint prot_ramen * ramen + prot_fries * fries >= min_prot;

% At most 30% of meals can be ramen:
% ramen <= 0.3*(ramen+fries)  <=>  10*ramen <= 3*(ramen+fries)  <=>  7*ramen <= 3*fries
constraint 7 * ramen <= 3 * fries;

% Objective: minimize sodium intake
var int: total_sodium = sod_ramen * ramen + sod_fries * fries;
solve minimize total_sodium;

output [
  "ramen = ", show(ramen), "\n",
  "fries = ", show(fries), "\n",
  "total_calories = ", show(cal_ramen * ramen + cal_fries * fries), "\n",
  "total_protein = ", show(prot_ramen * ramen + prot_fries * fries), "\n",
  "total_sodium = ", show(total_sodium), "\n"
];