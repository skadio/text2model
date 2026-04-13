% Ayse fertilizer blending (LP)
% Data embedded as per problem statement

float: cost_C = 2.0;
float: cost_Y = 3.0;

float: n2o_req = 5.0;
float: vit_req = 8.0;

float: n2o_perkg_C = 1.5;
float: vit_perkg_C = 3.0;

float: n2o_perkg_Y = 5.0;
float: vit_perkg_Y = 1.0;

% Decision variables (kg of each fertilizer)
var 0.0..1000.0: kg_C;
var 0.0..1000.0: kg_Y;

% Objective
var float: total_cost = cost_C * kg_C + cost_Y * kg_Y;

% Constraints
constraint n2o_perkg_C * kg_C + n2o_perkg_Y * kg_Y >= n2o_req;
constraint vit_perkg_C * kg_C + vit_perkg_Y * kg_Y >= vit_req;

solve minimize total_cost;

output [
  "kg_C = ", show(kg_C), "\n",
  "kg_Y = ", show(kg_Y), "\n",
  "total_cost = ", show(total_cost), "\n"
];