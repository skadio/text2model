% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [10, 4, 13, 15];
array[FOODS] of int: carbs   = [17, 3,  8, 25];
array[FOODS] of int: cal     = [159,126,230,112];
array[FOODS] of int: cost    = [5,  5,  8,  3];

int: minProtein = 66;
int: minCarbs   = 101;
int: minCal     = 1701;

int: maxCost = max(cost);
int: maxUnitsByProtein = (minProtein + min(protein) - 1) div min(protein);
int: maxUnitsByCarbs   = (minCarbs   + min(carbs)   - 1) div min(carbs);
int: maxUnitsByCal     = (minCal     + min(cal)     - 1) div min(cal);
int: maxUnitsPerFood   = max(maxUnitsByProtein, max(maxUnitsByCarbs, maxUnitsByCal));

% Variables
array[FOODS] of var 0..maxUnitsPerFood: x;
var 0..(maxUnitsPerFood * nFoods * maxCost): totalCost;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in FOODS)(cal[f]     * x[f]) >= minCal;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;