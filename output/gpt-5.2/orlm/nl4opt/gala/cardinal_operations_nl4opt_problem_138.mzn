% Diet meal-prep optimization (embedded data)

% Data
int: protein_smoothie = 2;
int: cal_smoothie     = 300;

int: protein_bar = 7;
int: cal_bar     = 250;

int: cal_limit = 2000;

% Decision variables
var 0..(cal_limit div cal_smoothie): smoothies;
var 0..(cal_limit div cal_bar): bars;

% Constraints
constraint bars = 2 * smoothies; % 2 times more bars than smoothies
constraint cal_smoothie * smoothies + cal_bar * bars <= cal_limit;

% Objective: maximize total protein
var int: total_protein = protein_smoothie * smoothies + protein_bar * bars;
solve maximize total_protein;

output [
  "Smoothies = ", show(smoothies), "\n",
  "Protein bars = ", show(bars), "\n",
  "Total calories = ", show(cal_smoothie * smoothies + cal_bar * bars), "\n",
  "Total protein = ", show(total_protein), "\n"
];