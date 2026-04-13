% Factory production planning: maximize profit under equipment-hour capacities

% Parameters
int: nProducts = 3;                 % Products I, II, III
int: nEquip = 3;                    % Equipment A, B, C

set of int: PRODUCTS = 1..nProducts;
set of int: EQUIP = 1..nEquip;

% hoursPerUnit[e,p] = equipment-hours required on equipment e to produce 1 unit of product p
array[EQUIP, PRODUCTS] of int: hoursPerUnit =
  [|  8,  2, 10
   | 10,  5,  8
   |  2, 13, 10
  |];

% Monthly available hours for equipment A, B, C
array[EQUIP] of int: capacityHours = [300, 400, 420];

% Profit per unit (thousand yuan) for products I, II, III
array[PRODUCTS] of float: profitPerUnit = [3.0, 2.0, 2.9];

% Variables
array[PRODUCTS] of var 0..intmax: x;  % Production quantities (nonnegative integers)

% Constraints: equipment capacities
constraint
  forall(e in EQUIP) (
    sum(p in PRODUCTS) (hoursPerUnit[e, p] * x[p]) <= capacityHours[e]
  );

% Objective (directly; avoids float(x[p]) syntax issue)
solve maximize sum(p in PRODUCTS) (profitPerUnit[p] * x[p]);