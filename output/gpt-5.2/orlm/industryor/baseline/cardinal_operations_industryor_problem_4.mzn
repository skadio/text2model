int: total_grams = 600;
float: budget = 15.0;

set of int: P = 1..3;
set of int: V = 1..4;

array[P] of float: priceP_per100 = [4.0, 3.6, 1.8]; % salmon, beef, pork
array[V] of float: priceV_per100 = [2.6, 1.2, 1.6, 2.3]; % okra, carrots, celery, cabbage
array[V] of float: fiberV_per100 = [3.2, 2.7, 1.6, 2.0]; % grams fiber per 100g

% Decision variables (grams)
array[P] of var 0..total_grams: gP;
array[V] of var 0..total_grams: gV;

% Selection variables
array[P] of var bool: chooseP;
array[V] of var bool: chooseV;

% Exactly one protein chosen
constraint sum(p in P)(bool2int(chooseP[p])) = 1;
constraint forall(p in P)(
  (chooseP[p] -> gP[p] > 0) /\
  (not chooseP[p] -> gP[p] = 0)
);

% At least two vegetables chosen
constraint sum(v in V)(bool2int(chooseV[v])) >= 2;
constraint forall(v in V)(
  (chooseV[v] -> gV[v] > 0) /\
  (not chooseV[v] -> gV[v] = 0)
);

% Total intake constraint
constraint sum(p in P)(gP[p]) + sum(v in V)(gV[v]) = total_grams;

% Budget constraint (prices are per 100g)
constraint
  sum(p in P)(priceP_per100[p] * int2float(gP[p]) / 100.0) +
  sum(v in V)(priceV_per100[v] * int2float(gV[v]) / 100.0)
  <= budget;

% Objective: maximize fiber intake from vegetables
var float: total_fiber =
  sum(v in V)(fiberV_per100[v] * int2float(gV[v]) / 100.0);

solve maximize total_fiber;

output [
  "Total fiber (g): ", show(total_fiber), "\n",
  "Protein grams [salmon, beef, pork]: ", show(gP), "\n",
  "Vegetable grams [okra, carrots, celery, cabbage]: ", show(gV), "\n",
  "Chosen protein: ", show(chooseP), "\n",
  "Chosen vegetables: ", show(chooseV), "\n",
  "Total cost ($): ",
    show(
      sum(p in P)(priceP_per100[p] * int2float(gP[p]) / 100.0) +
      sum(v in V)(priceV_per100[v] * int2float(gV[v]) / 100.0)
    ),
  "\n"
];