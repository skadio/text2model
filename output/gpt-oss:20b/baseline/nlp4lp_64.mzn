int: I;
int: J;
array[1..J] of int: FixedCosts;
array[1..I, 1..J] of int: AdditionalCosts;
int: MaxProjectsPerConsultant;

array[1..J] of var bool: hire;
array[1..I, 1..J] of var bool: assign;

constraint
  forall(i in 1..I) (
    sum(j in 1..J) assign[i,j] == 1
  ) /\
  forall(j in 1..J) (
    sum(i in 1..I) assign[i,j] <= MaxProjectsPerConsultant
  ) /\
  forall(i in 1..I, j in 1..J) (
    assign[i,j] <= hire[j]
  );

var int: totalCost = sum(j in 1..J) hire[j] * FixedCosts[j] + sum(i in 1..I, j in 1..J) assign[i,j] * AdditionalCosts[i,j];

solve minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "Hire: ", show(hire), "\n",
  "Assignments:\n",
  concat([ "Project ", show(i), ": ", show([j | j in 1..J where assign[i,j] = true]), "\n" | i in 1..I ])
];