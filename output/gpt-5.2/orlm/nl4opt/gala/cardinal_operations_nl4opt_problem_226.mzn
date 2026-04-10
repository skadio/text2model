include "globals.mzn";

/* Data (embedded from description) */
int: cal_salmon = 300;
int: prot_salmon = 15;
int: sod_salmon = 80;

int: cal_eggs = 200;
int: prot_eggs = 8;
int: sod_eggs = 20;

int: min_cal = 2000;
int: min_prot = 90;

/* Decision variables: number of bowls of each meal */
var 0..1000: salmon;
var 0..1000: eggs;

var 0..2000: total_meals;
constraint total_meals = salmon + eggs;
constraint total_meals >= 1; % avoid division-by-zero style issues in ratio constraint

/* Nutrition constraints */
constraint cal_salmon * salmon + cal_eggs * eggs >= min_cal;
constraint prot_salmon * salmon + prot_eggs * eggs >= min_prot;

/* At most 40% of meals are eggs: eggs <= 0.4 * total_meals  <=>  5*eggs <= 2*total_meals */
constraint 5 * eggs <= 2 * total_meals;

/* Objective: minimize sodium intake */
var int: sodium = sod_salmon * salmon + sod_eggs * eggs;
solve minimize sodium;

output [
  "salmon = ", show(salmon), "\n",
  "eggs = ", show(eggs), "\n",
  "total_meals = ", show(total_meals), "\n",
  "calories = ", show(cal_salmon*salmon + cal_eggs*eggs), "\n",
  "protein = ", show(prot_salmon*salmon + prot_eggs*eggs), "\n",
  "sodium = ", show(sodium), "\n"
];