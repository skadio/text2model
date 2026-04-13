include "globals.mzn";

% Foods: 1..9 = [Chicken, Rice, Apples, Steak, Lentils, Fish, Tofu, Cheese, Bread]
int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [15, 1, 1, 6, 3, 17, 18, 12, 2];
array[FOODS] of int: carbs   = [18,25,21, 3, 7, 13, 27, 17,30];
array[FOODS] of int: calories= [300,267,266,119,166,129,216, 76,258];
array[FOODS] of int: cost    = [ 4, 2, 5,10, 2, 8,10, 9, 4];

int: minProtein  = 90;
int: minCarbs    = 105;
int: minCalories = 1805;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bound chosen safely: you never need more than min requirement / smallest contribution
array[FOODS] of var 0..30: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [ show(totalCost) ];