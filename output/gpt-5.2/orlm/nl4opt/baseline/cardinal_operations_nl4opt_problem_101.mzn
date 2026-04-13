% Garden soil mix optimization: minimize daily water use

int: water_subsoil = 10;
int: water_topsoil = 6;

int: total_bags_limit = 150;
int: min_topsoil = 10;

float: max_topsoil_fraction = 0.30;

var 0..total_bags_limit: subsoil;
var 0..total_bags_limit: topsoil;

constraint subsoil + topsoil <= total_bags_limit;
constraint topsoil >= min_topsoil;
constraint topsoil <= floor(max_topsoil_fraction * int2float(subsoil + topsoil));

var 0..water_subsoil*total_bags_limit + water_topsoil*total_bags_limit: total_water;
constraint total_water = water_subsoil * subsoil + water_topsoil * topsoil;

solve minimize total_water;

output [
  "subsoil = ", show(subsoil), "\n",
  "topsoil = ", show(topsoil), "\n",
  "total_bags = ", show(subsoil + topsoil), "\n",
  "total_water = ", show(total_water), "\n"
];