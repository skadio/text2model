include "globals.mzn";

/*** Data (embedded from problem description) ***/
int: budget = 80;
int: solarMax = 50;
int: windMax  = 40;

int: scoreMin = 100;
int: scoreSolar = 3;
int: scoreWind  = 2;

int: costSolar = 10;
int: costWind  = 20;

/*** Decision variables (integer investments) ***/
var 0..solarMax: solar;
var 0..windMax: wind;

/*** Constraints ***/
constraint solar + wind <= budget;
constraint scoreSolar * solar + scoreWind * wind >= scoreMin;
constraint solar >= wind;

/*** Objective: minimize total cost ***/
var int: totalCost = costSolar * solar + costWind * wind;

solve minimize totalCost;

/*** Output (rounded to nearest whole number; already integer) ***/
output [
  "Minimum total cost (rounded) = ", show(totalCost), "\n",
  "Solar = ", show(solar), "\n",
  "Wind = ", show(wind), "\n"
];