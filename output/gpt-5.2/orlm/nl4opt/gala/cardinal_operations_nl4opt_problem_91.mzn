% Bodybuilder meal planning: minimize fat subject to nutrition and ratio constraints

% Data (embedded as requested)
int: prot_turkey = 20;
int: carbs_turkey = 30;
int: fat_turkey = 12;

int: prot_tuna = 18;
int: carbs_tuna = 25;
int: fat_tuna = 8;

int: req_prot = 150;
int: req_carbs = 200;

% Decision variables: number of each meal (nonnegative integers)
var 0..1000: turkey;   % turkey dinners
var 0..1000: tuna;     % tuna salad sandwiches

% Nutrition constraints (at least requirements)
constraint prot_turkey * turkey + prot_tuna * tuna >= req_prot;
constraint carbs_turkey * turkey + carbs_tuna * tuna >= req_carbs;

% At most 40% of meals are turkey:
% turkey / (turkey + tuna) <= 0.4  ==>  5*turkey <= 2*(turkey + tuna)  ==>  3*turkey <= 2*tuna
% (also implies if tuna=0 then turkey=0, so feasibility is fine)
constraint 3 * turkey <= 2 * tuna;

% Objective: minimize total fat
var 0..10000000: total_fat = fat_turkey * turkey + fat_tuna * tuna;

solve minimize total_fat;

output [
  "turkey = ", show(turkey), "\n",
  "tuna   = ", show(tuna), "\n",
  "total_protein = ", show(prot_turkey * turkey + prot_tuna * tuna), "\n",
  "total_carbs   = ", show(carbs_turkey * turkey + carbs_tuna * tuna), "\n",
  "total_fat     = ", show(total_fat), "\n"
];