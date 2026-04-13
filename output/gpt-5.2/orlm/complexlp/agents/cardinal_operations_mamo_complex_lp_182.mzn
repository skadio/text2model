% Parameters
%------------------------------------------------------------
% Resource availability (embedded as per instructions)
%------------------------------------------------------------
int: mango_stock = 25;
int: pineapple_stock = 10;
int: strawberry_stock = 120;

%------------------------------------------------------------
% Scale to eliminate fractions (LCM of 4 and 8 is 8)
%------------------------------------------------------------
int: scale = 8;

% Salad A uses: 1/4 mango, 1/8 pineapple, 3 strawberries
int: mango_use_A_scaled     = 2;  % (1/4)*8
int: pineapple_use_A_scaled = 1;  % (1/8)*8
int: strawberry_use_A       = 3;  % no scaling needed

% Salad B uses: 1/2 mango, 1/4 pineapple, 1 strawberry
int: mango_use_B_scaled     = 4;  % (1/2)*8
int: pineapple_use_B_scaled = 2;  % (1/4)*8
int: strawberry_use_B       = 1;

% Profit per unit
int: profit_A = 10;
int: profit_B = 20;

% Allowed deviation from fully using each fruit (<= 5 left or <= 5 extra used)
int: tolerance = 5;

% Scaled stocks for mango and pineapple
int: mango_stock_scaled     = mango_stock * scale;
int: pineapple_stock_scaled = pineapple_stock * scale;

%------------------------------------------------------------
% Safe explicit upper bounds for production (to keep domains finite)
% Based on allowing up to 'tolerance' deviation in usage
%------------------------------------------------------------
int: maxA_mango     = (mango_stock_scaled + tolerance * scale) div mango_use_A_scaled;
int: maxB_mango     = (mango_stock_scaled + tolerance * scale) div mango_use_B_scaled;
int: maxA_pineapple = (pineapple_stock_scaled + tolerance * scale) div pineapple_use_A_scaled;
int: maxB_pineapple = (pineapple_stock_scaled + tolerance * scale) div pineapple_use_B_scaled;
int: maxA_straw     = (strawberry_stock + tolerance) div strawberry_use_A;
int: maxB_straw     = (strawberry_stock + tolerance) div strawberry_use_B;

int: maxA = min([maxA_mango, maxA_pineapple, maxA_straw]);
int: maxB = min([maxB_mango, maxB_pineapple, maxB_straw]);

% Variables
%------------------------------------------------------------
% Decision variables: integer production quantities
%------------------------------------------------------------
var 0..maxA: xA;  % number of fruit salad A units
var 0..maxB: xB;  % number of fruit salad B units

% Objective variable
var int: total_profit;

% Constraints
%------------------------------------------------------------
% Profit definition
%------------------------------------------------------------
constraint
  total_profit = profit_A * xA + profit_B * xB;

%------------------------------------------------------------
% Mango usage within tolerance of stock (scaled)
%------------------------------------------------------------
constraint
  abs(mango_use_A_scaled * xA + mango_use_B_scaled * xB - mango_stock_scaled)
  <= tolerance * scale;

%------------------------------------------------------------
% Pineapple usage within tolerance of stock (scaled)
%------------------------------------------------------------
constraint
  abs(pineapple_use_A_scaled * xA + pineapple_use_B_scaled * xB - pineapple_stock_scaled)
  <= tolerance * scale;

%------------------------------------------------------------
% Strawberry usage within tolerance of stock (unscaled)
%------------------------------------------------------------
constraint
  abs(strawberry_use_A * xA + strawberry_use_B * xB - strawberry_stock)
  <= tolerance;

% Objective
solve maximize total_profit;