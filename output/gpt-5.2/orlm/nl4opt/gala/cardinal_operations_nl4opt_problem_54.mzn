% Diet / nutrition cost minimization (all data embedded)

% Data
int: minCalcium = 100;
int: minIron    = 50;

int: costMilk = 1;
int: calMilk  = 40;
int: ironMilk = 25;

int: costVeg  = 2;
int: calVeg   = 15;
int: ironVeg  = 30;

% Decision variables: number of servings (nonnegative integers)
% Safe upper bounds (tight enough for this small model)
var 0..100: milk;
var 0..100: veg;

% Nutrition constraints
constraint calMilk * milk + calVeg * veg >= minCalcium;
constraint ironMilk * milk + ironVeg * veg >= minIron;

% Objective: minimize total cost
var int: totalCost = costMilk * milk + costVeg * veg;

solve minimize totalCost;

output [
  "milk = ", show(milk), "\n",
  "veg = ", show(veg), "\n",
  "totalCost = ", show(totalCost), "\n",
  "calcium = ", show(calMilk * milk + calVeg * veg), "\n",
  "iron = ", show(ironMilk * milk + ironVeg * veg), "\n"
];