% Dinner planning - maximize fiber under budget and total grams
% Use integer arithmetic (scaled) to avoid float search/timeouts.

int: nProt = 3;
set of int: PROT = 1..nProt;
array[PROT] of string: prot_name = ["salmon","beef","pork"];

int: nVeg = 4;
set of int: VEG = 1..nVeg;
array[VEG] of string: veg_name = ["okra","carrots","celery","cabbage"];

int: total_grams = 600;

% Prices in cents per 100g (integers)
array[PROT] of int: prot_price_cents_per100 = [400, 360, 180];
array[VEG] of int: veg_price_cents_per100  = [260, 120, 160, 230];

% Fiber in tenths of grams per 100g (e.g., 3.2g -> 32)
array[VEG] of int: veg_fiber_tenths_per100 = [32, 27, 16, 20];

int: budget_cents = 1500;

% Variables
array[PROT] of var 0..1: choose_prot;
array[VEG] of var 0..1: choose_veg;

array[PROT] of var 0..total_grams: grams_prot;
array[VEG] of var 0..total_grams: grams_veg;

var 0..1000000: total_cost_cents;
var 0..1000000: total_fiber_tenths;

% Constraints
constraint sum(p in PROT)(choose_prot[p]) = 1;
constraint sum(v in VEG)(choose_veg[v]) >= 2;

constraint sum(p in PROT)(grams_prot[p]) + sum(v in VEG)(grams_veg[v]) = total_grams;

constraint forall(p in PROT)(grams_prot[p] <= total_grams * choose_prot[p]);
constraint forall(v in VEG)(grams_veg[v] <= total_grams * choose_veg[v]);

% Cost: cents = sum(price_cents_per100 * grams / 100)
constraint total_cost_cents =
    sum(p in PROT)( (prot_price_cents_per100[p] * grams_prot[p]) div 100 )
  + sum(v in VEG)( (veg_price_cents_per100[v]  * grams_veg[v])  div 100 );

constraint total_cost_cents <= budget_cents;

% Fiber: tenths of grams = sum(fiber_tenths_per100 * grams / 100)
constraint total_fiber_tenths =
  sum(v in VEG)( (veg_fiber_tenths_per100[v] * grams_veg[v]) div 100 );

solve maximize total_fiber_tenths;

output [
  "total_cost=$", show(total_cost_cents div 100), ".", show(total_cost_cents mod 100), "\n",
  "total_fiber=", show(total_fiber_tenths div 10), ".", show(total_fiber_tenths mod 10), " g\n",
  "protein:\n"
] ++
[
  prot_name[p] ++ ": " ++ show(grams_prot[p]) ++ " g\n" | p in PROT
] ++
[
  "vegetables:\n"
] ++
[
  veg_name[v] ++ ": " ++ show(grams_veg[v]) ++ " g\n" | v in VEG
];