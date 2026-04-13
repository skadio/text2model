include "globals.mzn";

% Foods: 1=Chicken, 2=Rice, 3=Eggs, 4=Broccoli, 5=Lentils, 6=Apples
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [18, 14, 18,  7, 15,  8];
array[FOODS] of int: carbs   = [ 5, 13,  4, 15, 17, 13];
array[FOODS] of int: cal     = [202,234,220,247, 88, 77];
array[FOODS] of int: price   = [ 1,  7,  4,  3,  1,  2];

int: reqProtein = 70;
int: reqCarbs   = 187;
int: reqCal     = 2181;

% Upper bounds (safe, based on meeting requirements with minimum per-item contribution)
int: maxProteinNeed = (reqProtein div min(protein)) + 1; % <= 11
int: maxCarbNeed    = (reqCarbs   div min(carbs)) + 1;   % <= 39
int: maxCalNeed     = (reqCal     div min(cal)) + 1;     % <= 29
int: maxQty = max(maxProteinNeed, max(maxCarbNeed, maxCalNeed)); % 39

array[FOODS] of var 0..maxQty: qty;

var int: totalProtein = sum(i in FOODS)(protein[i] * qty[i]);
var int: totalCarbs   = sum(i in FOODS)(carbs[i]   * qty[i]);
var int: totalCal     = sum(i in FOODS)(cal[i]     * qty[i]);
var int: totalCost    = sum(i in FOODS)(price[i]   * qty[i]);

constraint totalProtein >= reqProtein;
constraint totalCarbs   >= reqCarbs;
constraint totalCal     >= reqCal;

solve minimize totalCost;

output [
  "Quantities (Chicken,Rice,Eggs,Broccoli,Lentils,Apples) = ", show(qty), "\n",
  "TotalProtein = ", show(totalProtein), "\n",
  "TotalCarbs   = ", show(totalCarbs), "\n",
  "TotalCalories= ", show(totalCal), "\n",
  "TotalCost    = $", show(totalCost), "\n"
];