% Parameters
int: N = 3;
set of int: P = 1..N;

array[P] of int: labor = [3, 2, 6];
array[P] of int: material = [4, 3, 6];
array[P] of int: price = [120, 80, 180];
array[P] of int: varCost = [60, 40, 80];

int: laborAvail = 1500;
int: materialAvail = 1600;

array[P] of int: fixedCost = [2000, 1500, 1000];

array[P] of int: unitProfit = [price[i] - varCost[i] | i in P];

% Variables
array[P] of var 0..max(laborAvail, materialAvail): x;

var int: totalRevenue;
var int: totalVarCost;
var int: totalFixedCost;
var int: profit;

% Constraints
constraint sum(i in P)(labor[i] * x[i]) <= laborAvail;
constraint sum(i in P)(material[i] * x[i]) <= materialAvail;

constraint totalRevenue = sum(i in P)(price[i] * x[i]);
constraint totalVarCost = sum(i in P)(varCost[i] * x[i]);
constraint totalFixedCost = sum(i in P)(fixedCost[i]);

constraint profit = totalRevenue - totalVarCost - totalFixedCost;

% Objective
solve maximize profit;