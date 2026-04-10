% Cashews and almonds diet optimization (all data embedded)

int: cal_almond = 200;
int: prot_almond = 20;
int: fat_almond = 15;

int: cal_cashew = 300;
int: prot_cashew = 25;
int: fat_cashew = 12;

int: min_calories = 10000;
int: min_protein  = 800;

% Decision variables: number of servings (nonnegative integers)
var 0..100000: almonds;
var 0..100000: cashews;

% Nutritional requirements
constraint cal_almond * almonds + cal_cashew * cashews >= min_calories;
constraint prot_almond * almonds + prot_cashew * cashews >= min_protein;

% At least twice as many servings of almonds as cashews
constraint almonds >= 2 * cashews;

% Objective: minimize total fat intake
var int: total_fat = fat_almond * almonds + fat_cashew * cashews;

solve minimize total_fat;

output [
  "almonds = ", show(almonds), "\n",
  "cashews = ", show(cashews), "\n",
  "total_fat = ", show(total_fat), "\n",
  "total_calories = ", show(cal_almond * almonds + cal_cashew * cashews), "\n",
  "total_protein = ", show(prot_almond * almonds + prot_cashew * cashews), "\n"
];