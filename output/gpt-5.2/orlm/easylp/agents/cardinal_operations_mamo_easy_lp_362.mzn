% Parameters
int: nFields = 4;                         % number of fields
set of int: FIELDS = 1..nFields;          % field index set

int: nCrops = 4;                          % number of crops
set of int: CROPS = 1..nCrops;            % crop index set
int: CORN = 1;
int: WHEAT = 2;
int: SOYBEAN = 3;
int: RICE = 4;

% Field areas (acres) - all land is indivisible, so areas are integers
% NOTE: The problem statement does not provide the actual field areas.
% With areas left as all zeros, the model becomes degenerate (zero cost, constraints trivially satisfied).
% Replace these with the true field areas to get a meaningful solution.
array[FIELDS] of int: fieldArea = [0, 0, 0, 0];

% Cost per acre for each crop
array[CROPS] of int: costPerAcre = [3, 2, 5, 4];

% Global planting restriction limits (acres)
int: maxCerealArea = 500;                 % Corn + Wheat <= 500
int: maxWaterArea  = 400;                 % Soybean + Rice <= 400
int: minLegumeArea = 200;                 % Corn + Soybean >= 200 (as stated)
int: minGrainArea  = 300;                 % Wheat + Rice >= 300

% Variables
% plant[f,c] = 1 if field f is planted with crop c, else 0
array[FIELDS, CROPS] of var 0..1: plant;

% totalAreaCrop[c] = total acres planted with crop c
array[CROPS] of var 0..sum(fieldArea): totalAreaCrop;

% totalCost = total planting cost in dollars
var 0..(sum(fieldArea) * max(costPerAcre)): totalCost;

% Constraints
%--- Field assignment: each field planted with exactly one crop
constraint
  forall(f in FIELDS) (
    sum(c in CROPS)(plant[f,c]) = 1
  );

%--- Link totalAreaCrop with field decisions and field areas
constraint
  forall(c in CROPS) (
    totalAreaCrop[c] = sum(f in FIELDS)(fieldArea[f] * plant[f,c])
  );

%--- Cereal crops area restriction: Corn + Wheat <= maxCerealArea
constraint
  totalAreaCrop[CORN] + totalAreaCrop[WHEAT] <= maxCerealArea;

%--- Water availability restriction: Soybean + Rice <= maxWaterArea
constraint
  totalAreaCrop[SOYBEAN] + totalAreaCrop[RICE] <= maxWaterArea;

%--- Soil health (as stated): at least minLegumeArea acres of (Corn or Soybean)
constraint
  totalAreaCrop[CORN] + totalAreaCrop[SOYBEAN] >= minLegumeArea;

%--- Market demand: at least minGrainArea acres of (Wheat or Rice)
constraint
  totalAreaCrop[WHEAT] + totalAreaCrop[RICE] >= minGrainArea;

%--- Total cost definition from planted areas and costs
constraint
  totalCost = sum(c in CROPS)(totalAreaCrop[c] * costPerAcre[c]);

% Objective
solve minimize totalCost;