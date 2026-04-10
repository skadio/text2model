int: cal_salmon = 300;
int: prot_salmon = 15;
int: sod_salmon = 80;

int: cal_eggs = 200;
int: prot_eggs = 8;
int: sod_eggs = 20;

int: min_calories = 2000;
int: min_protein = 90;

% Decision variables: number of bowls/meals
var 0..1000: salmon;
var 0..1000: eggs;

% Nutritional requirements
constraint cal_salmon * salmon + cal_eggs * eggs >= min_calories;
constraint prot_salmon * salmon + prot_eggs * eggs >= min_protein;

% At most 40% of meals can be eggs:
% eggs <= 0.4*(eggs + salmon)  ->  3*eggs <= 2*salmon
constraint 3 * eggs <= 2 * salmon;

% Objective: minimize sodium intake
var int: total_sodium = sod_salmon * salmon + sod_eggs * eggs;
solve minimize total_sodium;

output [
  "salmon = ", show(salmon), "\n",
  "eggs = ", show(eggs), "\n",
  "total_calories = ", show(cal_salmon * salmon + cal_eggs * eggs), "\n",
  "total_protein = ", show(prot_salmon * salmon + prot_eggs * eggs), "\n",
  "total_sodium = ", show(total_sodium), "\n"
];