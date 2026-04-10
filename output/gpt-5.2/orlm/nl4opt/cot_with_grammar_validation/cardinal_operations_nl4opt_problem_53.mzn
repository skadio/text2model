float: cost_C = 2.0;
float: cost_Y = 3.0;

float: nitrous_req = 5.0;
float: vitamin_req = 8.0;

float: nitrous_perkg_C = 1.5;
float: vitamin_perkg_C = 3.0;

float: nitrous_perkg_Y = 5.0;
float: vitamin_perkg_Y = 1.0;

var float: kg_C;
var float: kg_Y;

constraint kg_C >= 0.0;
constraint kg_Y >= 0.0;

constraint nitrous_perkg_C * kg_C + nitrous_perkg_Y * kg_Y >= nitrous_req;
constraint vitamin_perkg_C * kg_C + vitamin_perkg_Y * kg_Y >= vitamin_req;

var float: total_cost;
constraint total_cost = cost_C * kg_C + cost_Y * kg_Y;

solve minimize total_cost;

output [
  "kg_C = ", show(kg_C), "\n",
  "kg_Y = ", show(kg_Y), "\n",
  "total_cost = ", show(total_cost), "\n"
];