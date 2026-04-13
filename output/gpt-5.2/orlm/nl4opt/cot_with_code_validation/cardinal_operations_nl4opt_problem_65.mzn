% Flooring production (all data embedded)

% Parameters
float: profit_laminate = 2.1;
float: profit_carpet   = 3.3;

int: demand_laminate_min = 15000;
int: demand_carpet_min   = 5000;

int: total_ship_min = 50000;

int: laminate_max = 40000;
int: carpet_max   = 20000;

% Decision variables (square feet produced)
var demand_laminate_min..laminate_max: x_laminate;
var demand_carpet_min..carpet_max:     x_carpet;

% Objective expression (avoid an extra float var/equality that can slow some solvers)
constraint x_laminate + x_carpet >= total_ship_min;

solve maximize profit_laminate * int2float(x_laminate)
             + profit_carpet   * int2float(x_carpet);

output [
  "x_laminate = ", show(x_laminate), "\n",
  "x_carpet   = ", show(x_carpet), "\n",
  "profit     = ", show(profit_laminate * int2float(x_laminate)
                      + profit_carpet   * int2float(x_carpet)), "\n"
];