float: b1_pancreas = 0.3;
float: b1_skin = 0.2;
float: b1_tumor = 0.6;

float: b2_pancreas = 0.2;
float: b2_skin = 0.1;
float: b2_tumor = 0.4;

float: max_skin = 4.0;
float: min_tumor = 3.0;

var 0.0..1000.0: x1;
var 0.0..1000.0: x2;

constraint b1_skin * x1 + b2_skin * x2 <= max_skin;
constraint b1_tumor * x1 + b2_tumor * x2 >= min_tumor;

solve minimize b1_pancreas * x1 + b2_pancreas * x2;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "pancreas=", show(b1_pancreas * x1 + b2_pancreas * x2), "\n",
  "skin=", show(b1_skin * x1 + b2_skin * x2), "\n",
  "tumor=", show(b1_tumor * x1 + b2_tumor * x2), "\n"
];