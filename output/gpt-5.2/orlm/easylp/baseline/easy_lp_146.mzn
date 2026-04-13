int: maxTanks = 20;
int: maxAircraft = 15;

int: tankSupport = 5;
int: aircraftSupport = 7;

var 0..maxTanks: Tanks;
var 0..maxAircraft: Aircraft;

constraint 3*Tanks + 2*Aircraft >= 10;
constraint 4*Tanks + Aircraft <= 30;

var int: totalSupport = tankSupport*Tanks + aircraftSupport*Aircraft;

solve minimize totalSupport;

output [
  "Tanks = ", show(Tanks), "\n",
  "Aircraft = ", show(Aircraft), "\n",
  "Minimum total support points = ", show(totalSupport), "\n"
];