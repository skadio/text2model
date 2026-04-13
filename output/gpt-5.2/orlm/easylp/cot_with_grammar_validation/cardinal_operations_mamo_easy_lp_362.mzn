% Parameters
int: nFields = 4;
set of int: FIELDS = 1..nFields;

int: nCrops = 4;
set of int: CROPS = 1..nCrops;

int: CORN = 1;
int: WHEAT = 2;
int: SOYBEAN = 3;
int: RICE = 4;

array[FIELDS] of int: field_area = [120, 150, 200, 180];

array[CROPS] of int: cost_per_acre = [3, 2, 5, 4];

int: max_cereal_area = 500;   % Corn + Wheat
int: max_water_area = 400;    % Soybean + Rice
int: min_legume_area = 200;   % Corn + Soybean
int: min_grain_area = 300;    % Wheat + Rice

% Variables
array[FIELDS, CROPS] of var 0..1: plant;

var 0..sum(f in FIELDS)(field_area[f] * max(cost_per_acre)): total_cost;

% Constraints
constraint forall(f in FIELDS) (
  sum(c in CROPS)(plant[f,c]) = 1
);

constraint
  sum(f in FIELDS)(
    field_area[f] * (plant[f, CORN] + plant[f, WHEAT])
  ) <= max_cereal_area;

constraint
  sum(f in FIELDS)(
    field_area[f] * (plant[f, SOYBEAN] + plant[f, RICE])
  ) <= max_water_area;

constraint
  sum(f in FIELDS)(
    field_area[f] * (plant[f, CORN] + plant[f, SOYBEAN])
  ) >= min_legume_area;

constraint
  sum(f in FIELDS)(
    field_area[f] * (plant[f, WHEAT] + plant[f, RICE])
  ) >= min_grain_area;

constraint
  total_cost = sum(f in FIELDS, c in CROPS)(field_area[f] * cost_per_acre[c] * plant[f,c]);

% Objective
solve minimize total_cost;