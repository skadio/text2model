int: platinum_available = 450;
int: palladium_available = 390;

int: platinum_palladiumHeavy = 15;
int: palladium_palladiumHeavy = 25;
int: rate_palladiumHeavy = 5;

int: platinum_platinumHeavy = 20;
int: palladium_platinumHeavy = 14;
int: rate_platinumHeavy = 4;

var 0..min(platinum_available div platinum_palladiumHeavy,
           palladium_available div palladium_palladiumHeavy): x_palladiumHeavy;
var 0..min(platinum_available div platinum_platinumHeavy,
           palladium_available div palladium_platinumHeavy): x_platinumHeavy;

constraint
  platinum_palladiumHeavy * x_palladiumHeavy +
  platinum_platinumHeavy * x_platinumHeavy <= platinum_available;

constraint
  palladium_palladiumHeavy * x_palladiumHeavy +
  palladium_platinumHeavy * x_platinumHeavy <= palladium_available;

var int: total_rate =
  rate_palladiumHeavy * x_palladiumHeavy +
  rate_platinumHeavy * x_platinumHeavy;

solve maximize total_rate;

output [
  "palladium-heavy catalysts = ", show(x_palladiumHeavy), "\n",
  "platinum-heavy catalysts  = ", show(x_platinumHeavy), "\n",
  "total conversion rate (units/s) = ", show(total_rate), "\n"
];