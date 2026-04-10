include "globals.mzn";

/* Decision variables: whole acres planted */
var int: wheat;
var int: corn;
var int: rice;
var int: barley;

/* No explicit numeric bounds were provided for each crop beyond integrality,
   so we assume nonnegative acres. Upper bounds can be safely derived from pairwise caps. */
constraint wheat >= 0;
constraint corn  >= 0;
constraint rice  >= 0;
constraint barley>= 0;

constraint wheat <= 500;
constraint corn  <= 500;
constraint rice  <= 600;
constraint barley<= 600;

/* Resource constraints */
constraint wheat + corn <= 500;      % soil suitability
constraint rice + barley <= 600;     % water availability

/* Diversity / demand constraints */
constraint wheat >= rice + 100;
constraint corn  >= barley + 200;

/* Cost (in dollars) */
var int: total_cost = 10*wheat + 20*corn + 30*rice + 40*barley;

solve minimize total_cost;

output [
  "wheat=", show(wheat), " acres\n",
  "corn=", show(corn), " acres\n",
  "rice=", show(rice), " acres\n",
  "barley=", show(barley), " acres\n",
  "total_cost=$", show(total_cost), "\n"
];