% Parameters (with values embedded)
int: nProt = 3;
set of int: PROT = 1..nProt;
array[PROT] of string: protName = ["salmon","beef","pork"];
array[PROT] of float: protPricePer100 = [4.0, 3.6, 1.8];

int: nVeg = 4;
set of int: VEG = 1..nVeg;
array[VEG] of string: vegName = ["okra","carrots","celery","cabbage"];
array[VEG] of float: vegFiberPer100 = [3.2, 2.7, 1.6, 2.0];
array[VEG] of float: vegPricePer100 = [2.6, 1.2, 1.6, 2.3];

float: budget = 15.0;
int: totalGrams = 600;

% Variables
array[PROT] of var 0..1: chooseProt;
array[VEG] of var 0..1: chooseVeg;

array[PROT] of var 0..totalGrams: gramsProt;
array[VEG] of var 0..totalGrams: gramsVeg;

var float: totalCost;
var float: totalFiber;

% Constraints
constraint sum(p in PROT)(chooseProt[p]) = 1;
constraint sum(v in VEG)(chooseVeg[v]) >= 2;

constraint sum(p in PROT)(gramsProt[p]) + sum(v in VEG)(gramsVeg[v]) = totalGrams;

% Link selection to amounts (if not selected, grams must be 0)
constraint forall(p in PROT)(gramsProt[p] <= totalGrams * chooseProt[p]);
constraint forall(v in VEG)(gramsVeg[v] <= totalGrams * chooseVeg[v]);

% Budget
constraint
  totalCost =
    sum(p in PROT)(protPricePer100[p] * (int2float(gramsProt[p]) / 100.0)) +
    sum(v in VEG)(vegPricePer100[v]  * (int2float(gramsVeg[v])  / 100.0));
constraint totalCost <= budget;

% Fiber (only from vegetables, as given)
constraint
  totalFiber =
    sum(v in VEG)(vegFiberPer100[v] * (int2float(gramsVeg[v]) / 100.0));

% Objective
solve maximize totalFiber;