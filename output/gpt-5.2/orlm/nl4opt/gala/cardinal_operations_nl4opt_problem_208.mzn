include "globals.mzn";

% Data (embedded)
int: prot_alpha = 30;
int: sugar_alpha = 20;
int: cal_alpha  = 350;

int: prot_omega = 20;
int: sugar_omega = 15;
int: cal_omega  = 300;

int: min_protein = 100;
int: min_calories = 2000;

int: max_omega_pct = 35; % percent

% Decision variables: number of bottles of each brand
% Upper bounds chosen safely: 0..100 is more than enough for these requirements
var 0..100: a; % alpha bottles
var 0..100: o; % omega bottles

% Requirements
constraint prot_alpha * a + prot_omega * o >= min_protein;
constraint cal_alpha  * a + cal_omega  * o >= min_calories;

% Omega share constraint: o/(a+o) <= 0.35  <=>  100*o <= 35*(a+o)
% (Also implies a+o > 0 unless o=0; the nutrition constraints already force positive total.)
constraint 100 * o <= max_omega_pct * (a + o);

% Objective: minimize total sugar intake
var int: total_sugar = sugar_alpha * a + sugar_omega * o;

solve minimize total_sugar;

output [
  "alpha_bottles = ", show(a), "\n",
  "omega_bottles = ", show(o), "\n",
  "total_sugar_g = ", show(total_sugar), "\n",
  "total_protein_g = ", show(prot_alpha*a + prot_omega*o), "\n",
  "total_calories = ", show(cal_alpha*a + cal_omega*o), "\n",
  "omega_fraction = ", show( if a+o > 0 then float(o)/float(a+o) else 0.0 endif ), "\n"
];