% Parameters
int: profit_A = 10;
int: profit_B = 20;

int: mango_stock = 25;
int: pineapple_stock = 10;
int: strawberry_stock = 120;

% Convert fractional fruit usage to integer units
% Let 1 "mango_unit" = 1/8 mango, 1 "pineapple_unit" = 1/8 pineapple
int: mango_units_stock = 8 * mango_stock;         % 200
int: pineapple_units_stock = 8 * pineapple_stock; % 80

% Resource usage per salad in converted units
int: mango_units_A = 2;       % 1/4 mango = 2/8
int: mango_units_B = 4;       % 1/2 mango = 4/8
int: pineapple_units_A = 1;   % 1/8 pineapple = 1/8
int: pineapple_units_B = 2;   % 1/4 pineapple = 2/8
int: strawberry_A = 3;
int: strawberry_B = 1;

% Allowed deviation: at most 5 units left or 5 additional units used
int: tol_mango_units = 8 * 5;       % 40 (in 1/8 mango units)
int: tol_pineapple_units = 8 * 5;   % 40 (in 1/8 pineapple units)
int: tol_strawberry = 5;

% Variables
var 0..mango_units_stock div mango_units_A: xA;
var 0..mango_units_stock div mango_units_B: xB;

% Constraints
constraint
  abs(mango_units_A * xA + mango_units_B * xB - mango_units_stock) <= tol_mango_units;

constraint
  abs(pineapple_units_A * xA + pineapple_units_B * xB - pineapple_units_stock) <= tol_pineapple_units;

constraint
  abs(strawberry_A * xA + strawberry_B * xB - strawberry_stock) <= tol_strawberry;

% Objective
solve maximize profit_A * xA + profit_B * xB;