% Parameters
int: total_budget = 100000;
int: minX = 30000;
int: minY = 20000;
int: minZ = 10000;

int: costX = 5000;
int: costY = 3000;
int: costZ = 2000;

int: thousand = 1000;

% Variables
var 0..total_budget: budgetX;
var 0..total_budget: budgetY;
var 0..total_budget: budgetZ;

var 0..(total_budget div thousand): kX;
var 0..(total_budget div thousand): kY;
var 0..(total_budget div thousand): kZ;

var 0..(costX*total_budget + costY*total_budget + costZ*total_budget): total_cost;

% Constraints
constraint budgetX + budgetY + budgetZ <= total_budget;

constraint budgetX >= minX;
constraint budgetY >= minY;
constraint budgetZ >= minZ;

constraint budgetX = thousand * kX;
constraint budgetY = thousand * kY;
constraint budgetZ = thousand * kZ;

constraint total_cost = costX * (budgetX div thousand)
                      + costY * (budgetY div thousand)
                      + costZ * (budgetZ div thousand);

% Objective
solve minimize total_cost;