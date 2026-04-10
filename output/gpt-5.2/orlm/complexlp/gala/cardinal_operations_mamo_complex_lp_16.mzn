include "globals.mzn";

% Foods: 1=Chicken, 2=Broccoli, 3=Beef, 4=Rice
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [10, 4, 13, 15];
array[FOODS] of int: carbs   = [17, 3,  8, 25];
array[FOODS] of int: calories= [159,126,230,112];
array[FOODS] of int: cost    = [5,  5,  8,  3];

int: reqProtein  = 66;
int: reqCarbs    = 101;
int: reqCalories = 1701;

% Decision: number of servings of each food (nonnegative integers)
% Safe upper bound: if only rice is used to meet calories => ceil(1701/112)=16
int: maxServ = 16;
array[FOODS] of var 0..maxServ: x;

var int: totalProtein  = sum(i in FOODS)(protein[i]  * x[i]);
var int: totalCarbs    = sum(i in FOODS)(carbs[i]    * x[i]);
var int: totalCalories = sum(i in FOODS)(calories[i] * x[i]);
var int: totalCost     = sum(i in FOODS)(cost[i]     * x[i]);

constraint totalProtein  >= reqProtein;
constraint totalCarbs    >= reqCarbs;
constraint totalCalories >= reqCalories;

solve minimize totalCost;

output [
  show(totalCost)
];