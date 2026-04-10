% Parameters
int: nProt = 3;
set of int: PROT = 1..nProt;
array[PROT] of string: prot_name = ["salmon","beef","pork"];
array[PROT] of int: prot_cost = [400,360,180]; % cents per 100g

int: nVeg = 4;
set of int: VEG = 1..nVeg;
array[VEG] of string: veg_name = ["okra","carrots","celery","cabbage"];
array[VEG] of int: veg_cost = [260,120,160,230]; % cents per 100g
array[VEG] of int: veg_fiber = [32,27,16,20]; % tenths of grams fiber per 100g

int: budget = 1500; % cents
int: total_grams = 600;

% Variables
array[PROT] of var 0..1: choose_prot;
array[PROT] of var 0..total_grams: grams_prot;

array[VEG] of var 0..total_grams: grams_veg;
array[VEG] of var 0..1: choose_veg;

var 0..1000000: total_fiber_tenths;

% Constraints
constraint sum(p in PROT)(choose_prot[p]) = 1;

constraint forall(p in PROT)(
  grams_prot[p] <= total_grams * choose_prot[p]
);
constraint sum(p in PROT)(grams_prot[p]) >= 1;

constraint sum(v in VEG)(choose_veg[v]) >= 2;
constraint forall(v in VEG)(
  grams_veg[v] <= total_grams * choose_veg[v]
);

constraint sum(p in PROT)(grams_prot[p]) + sum(v in VEG)(grams_veg[v]) = total_grams;

constraint
  sum(p in PROT)(prot_cost[p] * grams_prot[p]) +
  sum(v in VEG)(veg_cost[v] * grams_veg[v])
  <= budget * 100;

constraint total_fiber_tenths =
  sum(v in VEG)(veg_fiber[v] * grams_veg[v]);

% Objective
solve maximize total_fiber_tenths;