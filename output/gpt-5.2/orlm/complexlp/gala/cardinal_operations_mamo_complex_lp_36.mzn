% Diet / meal plan minimization (all data embedded)

% Decision variables: number of servings of each food item
var 0..10000: steak;
var 0..10000: eggs;
var 0..10000: pasta;
var 0..10000: chicken;

% Nutritional requirements (at least)
int: minProtein = 71;
int: minCarbs   = 141;
int: minCals    = 1839;

% Nutrients per serving and costs
int: pSteak = 20; int: cSteak = 2;  int: calSteak = 68;  int: costSteak = 4;
int: pEggs  = 7;  int: cEggs  = 3;  int: calEggs  = 143; int: costEggs  = 1;
int: pPasta = 1;  int: cPasta = 26; int: calPasta = 52;  int: costPasta = 9;
int: pChick = 10; int: cChick = 1;  int: calChick = 69;  int: costChick = 4;

% Constraints: meet minimum nutrition
constraint pSteak*steak + pEggs*eggs + pPasta*pasta + pChick*chicken >= minProtein;
constraint cSteak*steak + cEggs*eggs + cPasta*pasta + cChick*chicken >= minCarbs;
constraint calSteak*steak + calEggs*eggs + calPasta*pasta + calChick*chicken >= minCals;

% Objective: minimize cost
var 0..1000000: totalCost =
  costSteak*steak + costEggs*eggs + costPasta*pasta + costChick*chicken;

solve minimize totalCost;

% Output only the optimal cost value
output [ show(totalCost) ];