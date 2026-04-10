% Parameters
int: total_investment = 1000000;
int: min_X = 200000;
int: min_Y = 150000;
int: min_Z = 250000;

% Returns as integer basis points (1 bp = 0.01%) to keep everything integral
int: rX_bp = 200;   % 2.00%
int: rY_bp = 300;   % 3.00%
int: rZ_bp = 400;   % 4.00%

% Variables
var 0..total_investment: x;
var 0..total_investment: y;
var 0..total_investment: z;

var 0..(rZ_bp * total_investment): total_return_bp_dollars;

% Constraints
constraint x >= min_X;
constraint y >= min_Y;
constraint z >= min_Z;

constraint x + y + z = total_investment;

constraint total_return_bp_dollars = rX_bp * x + rY_bp * y + rZ_bp * z;

% Objective
solve minimize total_return_bp_dollars;

% Output: minimum total return rounded to nearest dollar
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_return_rounded=", show((total_return_bp_dollars + 5000) div 10000), "\n"
];