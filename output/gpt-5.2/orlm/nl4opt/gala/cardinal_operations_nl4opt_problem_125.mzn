% Gorilla diet optimization (bananas vs mangoes) - minimize sugar
include "globals.mzn";

% Data (embedded from problem statement)
int: calBan = 80;
int: potBan = 20;
int: sugBan = 10;

int: calMan = 100;
int: potMan = 15;
int: sugMan = 8;

int: minCal = 4000;
int: minPot = 150;

% Decision variables: number of each fruit (nonnegative integers)
var 0..1000: bananas;
var 0..1000: mangoes;

% Nutrient constraints
constraint calBan * bananas + calMan * mangoes >= minCal;
constraint potBan * bananas + potMan * mangoes >= minPot;

% Preference constraint: at most 33% of fruits can be mangoes
% mangoes / (bananas + mangoes) <= 0.33  <=>  100*mangoes <= 33*(bananas+mangoes)
% Also prevents the trivial 0/0 issue by enforcing total fruits > 0 (already implied by minCal).
constraint 100 * mangoes <= 33 * (bananas + mangoes);

% Objective: minimize total sugar intake
var int: totalSugar = sugBan * bananas + sugMan * mangoes;

solve minimize totalSugar;

output [
  "bananas = ", show(bananas), "\n",
  "mangoes = ", show(mangoes), "\n",
  "totalSugar = ", show(totalSugar), "\n",
  "totalCalories = ", show(calBan*bananas + calMan*mangoes), "\n",
  "totalPotassium = ", show(potBan*bananas + potMan*mangoes), "\n"
];