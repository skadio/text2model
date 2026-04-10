% Slime production optimization (all data embedded)

% Decision variables: number of times to use each beaker (nonnegative integers)
var 0..1000: b1;
var 0..1000: b2;

% Data (from description)
int: flour_avail = 150;
int: liquid_avail = 100;
int: waste_max = 30;

int: flour_b1 = 4;
int: liquid_b1 = 6;
int: slime_b1 = 5;
int: waste_b1 = 4;

int: flour_b2 = 6;
int: liquid_b2 = 3;
int: slime_b2 = 3;
int: waste_b2 = 2;

% Resource constraints
constraint flour_b1 * b1 + flour_b2 * b2 <= flour_avail;
constraint liquid_b1 * b1 + liquid_b2 * b2 <= liquid_avail;
constraint waste_b1 * b1 + waste_b2 * b2 <= waste_max;

% Objective: maximize slime produced
var int: slime_total = slime_b1 * b1 + slime_b2 * b2;

solve maximize slime_total;

output [
  "Beaker1 uses = ", show(b1), "\n",
  "Beaker2 uses = ", show(b2), "\n",
  "Total slime  = ", show(slime_total), "\n",
  "Flour used   = ", show(flour_b1*b1 + flour_b2*b2), " / ", show(flour_avail), "\n",
  "Liquid used  = ", show(liquid_b1*b1 + liquid_b2*b2), " / ", show(liquid_avail), "\n",
  "Waste made   = ", show(waste_b1*b1 + waste_b2*b2), " / ", show(waste_max), "\n"
];