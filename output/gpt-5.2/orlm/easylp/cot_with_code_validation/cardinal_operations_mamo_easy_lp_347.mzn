% Investment allocation problem (all data embedded)

% Parameters
int: total_invest = 10_000_000;
int: min_X = 2_000_000;
int: max_Y = 5_000_000;
int: min_Z = 1_500_000;
int: max_W = 3_000_000;

% Returns in percent (integer) to keep everything integral
int: rX = 5;
int: rY = 7;
int: rZ = 6;
int: rW = 8;

% Decision variables (whole dollars)
var min_X..total_invest: x;
var 0..max_Y: y;
var min_Z..total_invest: z;
var 0..max_W: w;

% Total return in cents to avoid rounding constraints and improve performance
var 0..(total_invest * 8): total_return_cents;

% Constraints
constraint x + y + z + w = total_invest;

% Return calculation: percent of dollars -> cents
constraint total_return_cents = rX * x + rY * y + rZ * z + rW * w;

% Objective: minimize total return
solve minimize total_return_cents;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "w=", show(w), "\n",
  "min_total_return_dollars=", show(total_return_cents div 100), "\n"
];