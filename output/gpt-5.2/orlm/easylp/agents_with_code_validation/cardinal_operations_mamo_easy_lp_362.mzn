% Parameters
int: nFields = 4;                          % Number of fields
set of int: FIELDS = 1..nFields;

% Crop identifiers
set of int: CROPS = 1..4;
int: CORN = 1;
int: WHEAT = 2;
int: SOYBEAN = 3;
int: RICE = 4;

% Field areas (acres)
% NOTE: The problem statement does not provide the acreage of each of the 4 fields.
% These must be known to compute costs and enforce area-based constraints.
% Replace the zeros with the actual integer acreages for each field.
array[FIELDS] of int: field_area = [0, 0, 0, 0];

% Planting restrictions (acres)
int: max_cereal_area = 500;                % Corn + Wheat max
int: max_water_area  = 400;                % Soybean + Rice max
int: min_legume_area = 200;                % Corn + Soybean min
int: min_grain_area  = 300;                % Wheat + Rice min

% Cost per acre ($)
array[CROPS] of int: cost_per_acre = [3, 2, 5, 4];

% Variables
array[FIELDS, CROPS] of var 0..1: plant;   % plant[f,c] = 1 if field f planted with crop c

var 0..sum(field_area): cereal_area;        % Total acres in Corn+Wheat
var 0..sum(field_area): water_area;         % Total acres in Soybean+Rice
var 0..sum(field_area): legume_area;        % Total acres in Corn+Soybean
var 0..sum(field_area): grain_area;         % Total acres in Wheat+Rice

var 0..(sum(field_area) * max(cost_per_acre)): total_cost; % Total planting cost ($)

% Constraints

%--------------------------------------------------------------------
% Each field is planted with exactly one crop
%--------------------------------------------------------------------
constraint
  forall(f in FIELDS) (
    sum(c in CROPS)(plant[f,c]) = 1
  );

%--------------------------------------------------------------------
% Define aggregate planted areas by crop groups (weighted by field area)
%--------------------------------------------------------------------
constraint
  cereal_area =
    sum(f in FIELDS)( field_area[f] * (plant[f,CORN] + plant[f,WHEAT]) );

constraint
  water_area  =
    sum(f in FIELDS)( field_area[f] * (plant[f,SOYBEAN] + plant[f,RICE]) );

constraint
  legume_area =
    sum(f in FIELDS)( field_area[f] * (plant[f,CORN] + plant[f,SOYBEAN]) );

constraint
  grain_area  =
    sum(f in FIELDS)( field_area[f] * (plant[f,WHEAT] + plant[f,RICE]) );

%--------------------------------------------------------------------
% Planting restriction limits and minimum requirements
%--------------------------------------------------------------------
constraint cereal_area <= max_cereal_area;        % Corn + Wheat <= 500
constraint water_area  <= max_water_area;         % Soybean + Rice <= 400
constraint legume_area >= min_legume_area;        % Corn + Soybean >= 200
constraint grain_area  >= min_grain_area;         % Wheat + Rice >= 300

%--------------------------------------------------------------------
% Total cost definition (sum over fields: area * selected crop cost)
%--------------------------------------------------------------------
constraint
  total_cost =
    sum(f in FIELDS, c in CROPS)( field_area[f] * cost_per_acre[c] * plant[f,c] );

% Objective
solve minimize total_cost;