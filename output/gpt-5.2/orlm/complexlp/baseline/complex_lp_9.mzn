% Diet optimization: minimize cost while meeting nutrient requirements.

int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = [
  "Chicken breast", "Tofu", "Spinach", "Beef steak",
  "Eggs", "Brown rice", "Bananas", "Quinoa"
];

array[FOODS] of int: cost =    [7, 7, 1, 9, 6, 7, 2, 6];
array[FOODS] of int: protein = [12,10,11, 8,16, 4, 4, 4];
array[FOODS] of int: carbs =   [ 5, 1,30,26, 9,25,16,20];
array[FOODS] of int: cal =     [231,210,295,211,232,146,255,205];

int: reqProtein = 91;
int: reqCarbs   = 136;
int: reqCal     = 1563;

% Decision: number of servings of each food (nonnegative integers).
% Upper bound chosen conservatively from calorie requirement.
array[FOODS] of var 0..20: x;

constraint sum(f in FOODS)(protein[f] * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(cal[f]     * x[f]) >= reqCal;

var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize totalCost;

output [
  show(totalCost)
];