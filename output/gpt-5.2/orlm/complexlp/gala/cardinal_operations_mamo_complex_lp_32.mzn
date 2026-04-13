% Diet / meal planning: minimize cost while meeting minimum nutrient targets
% All data embedded as requested.

int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Pasta","Avocado","Chicken","Tofu","Spinach","Cheese"];

array[FOODS] of int: protein = [15,20,15,19,19,12];
array[FOODS] of int: carbs   = [30,16, 8, 5,28,17];
array[FOODS] of int: calories= [154,111,211,87,98,231];
array[FOODS] of int: cost    = [3,  8,  7, 2, 9, 10];

int: minProtein = 73;
int: minCarbs   = 111;
int: minCalories= 2196;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bound chosen safely from calorie requirement and smallest calories per serving (87 for tofu)
int: maxServ = 26; % ceil(2196/87)=26
array[FOODS] of var 0..maxServ: x;

% Nutrient constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;

% Single-answer output: only the optimal value
output [show(totalCost)];