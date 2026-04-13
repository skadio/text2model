% Production planning with optional overtime assembly
% Maximize profit; report rounded to nearest dollar.

int: scale = 24; % LCM to clear fractions (1/4,1/8,1/3)

% Decision variables: number of units produced (nonnegative integers)
var 0..100000: x1; % product type 1
var 0..100000: x2; % product type 2

% Overtime assembly hours (can be fractional in reality; model with 1/scale hours)
var 0..(50*scale): otA_s; % overtime assembly in scaled hours (otA_s/scale)

% Constraints (all in scaled hours)
constraint (6*x1 + 8*x2) <= 90*scale + otA_s;   % assembly: 1/4=6/24, 1/3=8/24
constraint (3*x1 + 8*x2) <= 80*scale;           % testing: 1/8=3/24, 1/3=8/24
constraint otA_s <= 50*scale;

% Objective in cents to keep integer arithmetic
% Revenue: x1*$9 + x2*$8
% Raw materials: x1*$1.2 + x2*$0.9
% Overtime cost: $9 per hour * (otA_s/scale)
int: rev1_c = 900;
int: rev2_c = 800;
int: rm1_c  = 120;
int: rm2_c  = 90;
int: ot_c_per_hour = 900;

var int: profit_cents =
    (rev1_c - rm1_c) * x1
  + (rev2_c - rm2_c) * x2
  - (ot_c_per_hour * otA_s) div scale;

solve maximize profit_cents;

% Rounded to nearest dollar:
% dollars = profit_cents/100
% rounded = floor(dollars + 0.5) = floor((profit_cents + 50)/100)
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "overtime_assembly_hours=", show(otA_s), "/", show(scale), "\n",
  "profit_cents=", show(profit_cents), "\n",
  "profit_rounded_dollars=", show( (profit_cents + 50) div 100 ), "\n"
];