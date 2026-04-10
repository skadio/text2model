% Diet drink optimization: minimize sugar intake

int: protein_alpha = 30;
int: sugar_alpha   = 20;
int: calories_alpha = 350;

int: protein_omega = 20;
int: sugar_omega   = 15;
int: calories_omega = 300;

int: min_protein = 100;
int: min_calories = 2000;

int: omega_percent_max = 35; % at most 35% omega

var 0..200: x_alpha; % bottles of alpha
var 0..200: x_omega; % bottles of omega

% Requirements
constraint protein_alpha * x_alpha + protein_omega * x_omega >= min_protein;
constraint calories_alpha * x_alpha + calories_omega * x_omega >= min_calories;

% Omega proportion constraint: x_omega / (x_alpha + x_omega) <= 0.35
% Cross-multiplied (and avoid division):
% 100*x_omega <= 35*(x_alpha + x_omega)  <=> 65*x_omega <= 35*x_alpha
constraint x_alpha + x_omega > 0;
constraint 65 * x_omega <= omega_percent_max * x_alpha;

% Objective: minimize total sugar
var int: total_sugar = sugar_alpha * x_alpha + sugar_omega * x_omega;
solve minimize total_sugar;

output [
  "alpha bottles = ", show(x_alpha), "\n",
  "omega bottles = ", show(x_omega), "\n",
  "total sugar (g) = ", show(total_sugar), "\n",
  "total protein (g) = ", show(protein_alpha * x_alpha + protein_omega * x_omega), "\n",
  "total calories = ", show(calories_alpha * x_alpha + calories_omega * x_omega), "\n"
];