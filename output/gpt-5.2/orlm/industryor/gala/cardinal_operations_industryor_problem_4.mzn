include "globals.mzn";

% Data (per 100 grams)
int: nProt = 3;
set of int: PROT = 1..nProt;
array[PROT] of int: prot_cost = [400, 360, 180]; % cents per 100g: salmon, beef, pork

int: nVeg = 4;
set of int: VEG = 1..nVeg;
array[VEG] of int: veg_cost  = [260, 120, 160, 230]; % cents per 100g: okra, carrots, celery, cabbage
array[VEG] of int: veg_fiber = [32, 27, 16, 20];     % fiber in decigrams per 100g: 3.2,2.7,1.6,2.0 g

int: budget_cents = 1500;   % $15
int: total_grams  = 600;

% Decision variables
array[PROT] of var 0..6: prot_units; % units of 100g
array[VEG]  of var 0..6: veg_units;  % units of 100g
array[VEG]  of var 0..1: veg_used;

% Exactly one protein is chosen (positive amount), the others are zero
array[PROT] of var 0..1: prot_used;

% Constraints

% Total intake: 600 grams = 6 units of 100g
constraint sum(p in PROT)(prot_units[p]) + sum(v in VEG)(veg_units[v]) = total_grams div 100;

% Budget in cents
constraint sum(p in PROT)(prot_cost[p] * prot_units[p]) +
           sum(v in VEG)(veg_cost[v]  * veg_units[v]) <= budget_cents;

% Link usage indicators for vegetables (used iff positive amount)
constraint forall(v in VEG)(
  veg_units[v] >= veg_used[v] /\
  veg_units[v] <= 6 * veg_used[v]
);

% At least two kinds of vegetables
constraint sum(v in VEG)(veg_used[v]) >= 2;

% Link usage indicators for protein and enforce exactly one protein chosen
constraint forall(p in PROT)(
  prot_units[p] >= prot_used[p] /\
  prot_units[p] <= 6 * prot_used[p]
);
constraint sum(p in PROT)(prot_used[p]) = 1;

% Objective: maximize fiber from vegetables (protein fiber not given -> assume 0)
var int: total_fiber_dg = sum(v in VEG)(veg_fiber[v] * veg_units[v]); % decigrams
solve maximize total_fiber_dg;

% Output in grams and fiber in grams
array[PROT] of string: prot_name = ["salmon","beef","pork"];
array[VEG]  of string: veg_name  = ["okra","carrots","celery","cabbage"];

output [
  "Protein chosen (100g units):\n",
  concat([prot_name[p] ++ ": " ++ show(prot_units[p]) ++ " (" ++ show(prot_units[p]*100) ++ "g)\n" | p in PROT]),
  "Vegetables (100g units):\n",
  concat([veg_name[v] ++ ": " ++ show(veg_units[v]) ++ " (" ++ show(veg_units[v]*100) ++ "g)\n" | v in VEG]),
  "Total cost ($): ",
  show( (sum(p in PROT)(prot_cost[p]*prot_units[p]) + sum(v in VEG)(veg_cost[v]*veg_units[v])) / 100.0 ),
  "\nTotal fiber (g): ",
  show(total_fiber_dg / 10.0),
  "\n"
];