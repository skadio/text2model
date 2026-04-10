% Parameters
% Sets / dimensions
int: nProducts = 3;          % Products I, II, III
int: nEquip = 3;             % Equipment A, B, C
set of int: PRODUCTS = 1..nProducts;
set of int: EQUIP = 1..nEquip;

% Processing hours required per unit product on each equipment
% rows: A,B,C (1..3), cols: I,II,III (1..3)
array[EQUIP, PRODUCTS] of int: hours_per_unit =
  array2d(EQUIP, PRODUCTS,
    [  8,  2, 10,   % A
      10,  5,  8,   % B
       2, 13, 10    % C
    ]);

% Effective monthly equipment hours available
array[EQUIP] of int: capacity_hours = [300, 400, 420];  % A, B, C

% Unit product profit (per thousand yuan)
array[PRODUCTS] of float: profit = [3.0, 2.0, 2.9];     % I, II, III

% Derived bounds for production variables (simple safe upper bounds)
array[PRODUCTS] of int: max_prod =
  [ min([capacity_hours[e] div hours_per_unit[e,p] | e in EQUIP])
    | p in PRODUCTS
  ];

% Variables
% Production quantity of each product (units/month)
array[PRODUCTS] of var 0..max_prod[p]: x;  % x[p] = quantity of product p

% Constraints
% Equipment capacity constraints: total hours used on each equipment
% by all products cannot exceed the available monthly hours.
constraint
  forall(e in EQUIP) (
    sum(p in PRODUCTS)(hours_per_unit[e,p] * x[p]) <= capacity_hours[e]
  );

% Objective
solve maximize sum(p in PRODUCTS)(profit[p] * x[p]);