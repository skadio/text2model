% Supply chain resource allocation optimization (all data embedded)

var int: x;
var int: y;
var int: z;

constraint x + y + z <= 1000;
constraint x >= y + 200;
constraint z >= y + 50;

% Nonnegativity (implied by "allocation", and needed to avoid unbounded objective)
constraint x >= 0 /\ y >= 0 /\ z >= 0;

var int: total_cost = 4*x + 5*y + 6*z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];