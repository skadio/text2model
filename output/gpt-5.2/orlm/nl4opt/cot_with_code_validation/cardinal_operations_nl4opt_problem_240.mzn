% Parameters
int: steel_required = 520;
int: waste_limit = 400;

int: nEquip = 2;
set of int: EQUIP = 1..nEquip;

array[EQUIP] of int: steel_per_day = [25, 5];
array[EQUIP] of int: waste_per_day = [25, 3];

% Variables
array[EQUIP] of var 0..steel_required: x;

% Constraints
constraint
  sum(e in EQUIP)(steel_per_day[e] * x[e]) >= steel_required;

constraint
  sum(e in EQUIP)(waste_per_day[e] * x[e]) <= waste_limit;

% Objective
solve minimize sum(e in EQUIP)(x[e]);