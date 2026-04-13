% Medicine requirements (grams)
float: req_Z1 = 5.0;
float: req_D3 = 10.0;

% Pills: 1 = Zodiac, 2 = Sunny
set of int: P = 1..2;
array[P] of float: z1_per_pill = [1.3, 1.2];
array[P] of float: d3_per_pill = [1.5, 5.0];
array[P] of float: cost_per_pill = [1.0, 3.0];

% Decision variables: number of pills (LP => continuous)
array[P] of var float: x;
var float: total_cost;

% Nonnegativity
constraint forall(p in P)(x[p] >= 0.0);

% Requirements
constraint sum(p in P)(z1_per_pill[p] * x[p]) >= req_Z1;
constraint sum(p in P)(d3_per_pill[p] * x[p]) >= req_D3;

% Cost
constraint total_cost = sum(p in P)(cost_per_pill[p] * x[p]);

solve minimize total_cost;

output [
  "Zodiac pills = ", show(x[1]), "\n",
  "Sunny pills  = ", show(x[2]), "\n",
  "Total cost   = ", show(total_cost), "\n"
];