% Training regime optimization (embedded data)

int: intensity_X = 8;
int: intensity_Y = 12;

int: max_time = 20;

int: eff_coeff_X = 5;
int: eff_coeff_Y = 3;
int: min_effectiveness = 15;

var 0..max_time: x; % hours on exercise X (integer)
var 0..max_time: y; % hours on exercise Y (integer)

constraint x + y <= max_time;
constraint eff_coeff_X * x + eff_coeff_Y * y >= min_effectiveness;

var int: total_intensity = intensity_X * x + intensity_Y * y;

solve minimize total_intensity;

output [
  "x_hours = ", show(x), "\n",
  "y_hours = ", show(y), "\n",
  "min_total_intensity = ", show(total_intensity), "\n"
];