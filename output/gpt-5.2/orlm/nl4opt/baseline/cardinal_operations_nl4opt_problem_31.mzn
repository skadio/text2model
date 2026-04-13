int: wood_available = 300;
int: oxygen_available = 300;

int: wood_with = 10;
int: oxygen_with = 20;
int: co2_with = 15;

int: wood_without = 15;
int: oxygen_without = 12;
int: co2_without = 18;

var 0..wood_available div wood_with: x_with;
var 0..wood_available div wood_without: x_without;

constraint wood_with * x_with + wood_without * x_without <= wood_available;
constraint oxygen_with * x_with + oxygen_without * x_without <= oxygen_available;

var int: total_co2 = co2_with * x_with + co2_without * x_without;

solve maximize total_co2;

output [
  "process_with_catalyst = ", show(x_with), "\n",
  "process_without_catalyst = ", show(x_without), "\n",
  "total_co2 = ", show(total_co2), "\n",
  "wood_used = ", show(wood_with * x_with + wood_without * x_without), " / ", show(wood_available), "\n",
  "oxygen_used = ", show(oxygen_with * x_with + oxygen_without * x_without), " / ", show(oxygen_available), "\n"
];