% Slime production optimization (all data embedded)

int: flour_avail = 150;
int: liquid_avail = 100;
int: waste_max = 30;

% Beaker 1 coefficients
int: flour1 = 4;
int: liquid1 = 6;
int: slime1 = 5;
int: waste1 = 4;

% Beaker 2 coefficients
int: flour2 = 6;
int: liquid2 = 3;
int: slime2 = 3;
int: waste2 = 2;

% Decision variables: number of times to use each beaker
var 0..1000: x1;
var 0..1000: x2;

% Resource constraints
constraint flour1*x1 + flour2*x2 <= flour_avail;
constraint liquid1*x1 + liquid2*x2 <= liquid_avail;
constraint waste1*x1 + waste2*x2 <= waste_max;

% Objective: maximize total slime produced
var int: total_slime = slime1*x1 + slime2*x2;
solve maximize total_slime;

output [
  "Beaker1 uses: ", show(x1), "\n",
  "Beaker2 uses: ", show(x2), "\n",
  "Total slime: ", show(total_slime), "\n",
  "Flour used: ", show(flour1*x1 + flour2*x2), " / ", show(flour_avail), "\n",
  "Liquid used: ", show(liquid1*x1 + liquid2*x2), " / ", show(liquid_avail), "\n",
  "Waste produced: ", show(waste1*x1 + waste2*x2), " / ", show(waste_max), "\n"
];