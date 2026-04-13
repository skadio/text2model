% Parameters
int: nProt = 3;
set of int: PROT = 1..nProt;
array[PROT] of string: prot_name = ["salmon","beef","pork"];
array[PROT] of int: prot_cost_cents_per100g = [400, 360, 180];

int: nVeg = 4;
set of int: VEG = 1..nVeg;
array[VEG] of string: veg_name = ["okra","carrots","celery","cabbage"];
array[VEG] of int: veg_cost_cents_per100g = [260, 120, 160, 230];

% Fiber (tenths of grams) per 100g to keep integer arithmetic:
% okra 3.2 -> 32, carrots 2.7 -> 27, celery 1.6 -> 16, cabbage 2.0 -> 20
array[VEG] of int: veg_fiber_tenths_per100g = [32, 27, 16, 20];

int: budget_cents = 1500;     % $15.00
int: total_grams = 600;

% Variables
array[PROT] of var 0..1: choose_prot;
array[VEG] of var 0..1: choose_veg;

% grams, restricted to multiples of 100g so prices/fiber per 100g apply exactly
array[PROT] of var 0..total_grams: grams_prot;
array[VEG] of var 0..total_grams: grams_veg;

var 0..100000: total_cost_cents;
var 0..100000: total_fiber_tenths;

% Constraints
constraint sum(p in PROT)(choose_prot[p]) = 1;
constraint sum(v in VEG)(choose_veg[v]) >= 2;

% Link selection to grams
constraint forall(p in PROT)(grams_prot[p] <= total_grams * choose_prot[p]);
constraint forall(v in VEG)(grams_veg[v] <= total_grams * choose_veg[v]);

% Force 100g increments
constraint forall(p in PROT)(grams_prot[p] mod 100 = 0);
constraint forall(v in VEG)(grams_veg[v] mod 100 = 0);

% Total intake
constraint sum(p in PROT)(grams_prot[p]) + sum(v in VEG)(grams_veg[v]) = total_grams;

% Budget
constraint total_cost_cents =
  sum(p in PROT)(prot_cost_cents_per100g[p] * (grams_prot[p] div 100)) +
  sum(v in VEG)(veg_cost_cents_per100g[v] * (grams_veg[v] div 100));
constraint total_cost_cents <= budget_cents;

% Objective: maximize total fiber (from vegetables only, as given)
constraint total_fiber_tenths =
  sum(v in VEG)(veg_fiber_tenths_per100g[v] * (grams_veg[v] div 100));

% Objective
solve maximize total_fiber_tenths;