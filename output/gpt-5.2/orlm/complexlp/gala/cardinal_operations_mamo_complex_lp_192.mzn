% Product mix optimization (integer units), maximize profit.
% All data embedded as required.

% Decision variables: number of units produced (nonnegative integers)
var 0..10000: x1;  % product type 1
var 0..10000: x2;  % product type 2

% Overtime assembly hours (can schedule up to 50 hours)
var 0..50: ot;

% Data (hours per unit and costs/values)
float: asm1 = 1.0/4.0;
float: tst1 = 1.0/8.0;
float: mat1 = 1.2;
float: val1 = 9.0;

float: asm2 = 1.0/3.0;
float: tst2 = 1.0/3.0;
float: mat2 = 0.9;
float: val2 = 8.0;

float: asm_cap = 90.0;   % regular assembly hours
float: tst_cap = 80.0;   % testing hours
float: ot_cost = 7.0;    % $/hour overtime assembly

% Use exact rational form via integer-multiplied constraints to avoid rounding:
% Assembly: (1/4)x1 + (1/3)x2 <= 90 + ot  => multiply by 12:
constraint 3*x1 + 4*x2 <= 12*90 + 12*ot;

% Testing: (1/8)x1 + (1/3)x2 <= 80  => multiply by 24:
constraint 3*x1 + 8*x2 <= 24*80;

% Profit in cents, to keep everything integral; then round to nearest dollar for output.
% Unit profit:
% type1: 9 - 1.2 = 7.8  => 780 cents
% type2: 8 - 0.9 = 7.1  => 710 cents
% Overtime cost: $7/hr => 700 cents/hr
var int: profit_cents = 780*x1 + 710*x2 - 700*ot;

solve maximize profit_cents;

% Rounded to nearest dollar:
% profit_dollars_rounded = floor((profit_cents + 50)/100)
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "overtime_hours = ", show(ot), "\n",
  "profit_rounded_dollars = ", show( (profit_cents + 50) div 100 ), "\n"
];