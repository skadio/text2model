% Parameters (with values embedded)
int: nProducts = 2;
set of int: P = 1..nProducts;

int: GRAPH = 1;
int: MUSIC = 2;

float: maxMinutesPerDay = 350.0;

array[P] of float: printMinutes = [3.0, 1.5];
array[P] of float: scanMinutes  = [5.5, 3.0];

array[P] of float: profitPerReam = [4.0, 2.5];

% Variables
array[P] of var int: reams;          % reams produced of each type
var float: totalProfit;

% Constraints
constraint forall(p in P)(reams[p] >= 0);

constraint sum(p in P)(printMinutes[p] * int2float(reams[p])) <= maxMinutesPerDay;
constraint sum(p in P)(scanMinutes[p]  * int2float(reams[p])) <= maxMinutesPerDay;

constraint totalProfit = sum(p in P)(profitPerReam[p] * int2float(reams[p]));

% Objective
solve maximize totalProfit;