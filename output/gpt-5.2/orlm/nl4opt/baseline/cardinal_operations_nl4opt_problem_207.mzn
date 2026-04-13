int: max_sticks = 600;
int: max_glue = 100;

int: sticks_beam = 30;
int: glue_beam = 5;
int: mass_beam = 40;

int: sticks_truss = 50;
int: glue_truss = 8;
int: mass_truss = 60;

int: max_truss = 5;

var 0..(max_sticks div sticks_beam): beam;
var 0..max_truss: truss;

constraint sticks_beam * beam + sticks_truss * truss <= max_sticks;
constraint glue_beam * beam + glue_truss * truss <= max_glue;
constraint beam > truss;

var int: total_mass = mass_beam * beam + mass_truss * truss;

solve maximize total_mass;

output [
  "beam = ", show(beam), "\n",
  "truss = ", show(truss), "\n",
  "total_mass = ", show(total_mass), " grams\n"
];