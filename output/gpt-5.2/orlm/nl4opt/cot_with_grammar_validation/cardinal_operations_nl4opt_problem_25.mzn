float: req_Z1 = 5.0;
float: req_D3 = 10.0;

float: z1_per_Zodiac = 1.3;
float: z1_per_Sunny = 1.2;

float: d3_per_Zodiac = 1.5;
float: d3_per_Sunny = 5.0;

float: cost_Zodiac = 1.0;
float: cost_Sunny = 3.0;

var float: x_Zodiac;
var float: x_Sunny;

constraint x_Zodiac >= 0.0;
constraint x_Sunny >= 0.0;

constraint z1_per_Zodiac * x_Zodiac + z1_per_Sunny * x_Sunny >= req_Z1;
constraint d3_per_Zodiac * x_Zodiac + d3_per_Sunny * x_Sunny >= req_D3;

solve minimize cost_Zodiac * x_Zodiac + cost_Sunny * x_Sunny;

output [
  "x_Zodiac = ", show(x_Zodiac), "\n",
  "x_Sunny = ", show(x_Sunny), "\n",
  "min_cost = ", show(cost_Zodiac * x_Zodiac + cost_Sunny * x_Sunny), "\n"
];