% Crop planning for 4 fields with acreage limits and minimum group acreages.
% All data is embedded as requested.

include "globals.mzn";

%----------------------%
% Data
%----------------------%
int: nFields = 4;

set of int: CROPS = 1..4;
int: CORN = 1;
int: WHEAT = 2;
int: SOYBEAN = 3;
int: RICE = 4;

array[CROPS] of int: cost = [3, 2, 5, 4]; % $/acre for [Corn, Wheat, Soybean, Rice]

% If field areas are not provided, we must model them as decision variables.
% Bounds chosen large enough to not bind optimality given the stated constraints.
int: MAX_AREA = 1000;

%----------------------%
% Decision variables
%----------------------%
array[1..nFields] of var CROPS: crop;            % crop planted in field i
array[1..nFields] of var 0..MAX_AREA: area;      % acres of field i (integer)

%----------------------%
% Helper expressions
%----------------------%
var 0..nFields*MAX_AREA: acresCorn =
  sum(i in 1..nFields)( area[i] * bool2int(crop[i] = CORN) );
var 0..nFields*MAX_AREA: acresWheat =
  sum(i in 1..nFields)( area[i] * bool2int(crop[i] = WHEAT) );
var 0..nFields*MAX_AREA: acresSoy =
  sum(i in 1..nFields)( area[i] * bool2int(crop[i] = SOYBEAN) );
var 0..nFields*MAX_AREA: acresRice =
  sum(i in 1..nFields)( area[i] * bool2int(crop[i] = RICE) );

var 0..nFields*MAX_AREA: acresCereals = acresCorn + acresWheat;  % Corn + Wheat
var 0..nFields*MAX_AREA: acresWater   = acresSoy + acresRice;    % Soybean + Rice
var 0..nFields*MAX_AREA: acresLegumes = acresCorn + acresSoy;    % (as stated) Corn or Soybean
var 0..nFields*MAX_AREA: acresGrains  = acresWheat + acresRice;  % Wheat or Rice

var 0..intmax: totalCost =
  sum(i in 1..nFields)( area[i] * cost[crop[i]] );

%----------------------%
% Constraints
%----------------------%
% Plant all four fields: each field must have positive acreage.
constraint forall(i in 1..nFields)( area[i] >= 1 );

% Restrictions
constraint acresCereals <= 500;
constraint acresWater   <= 400;
constraint acresLegumes >= 200;
constraint acresGrains  >= 300;

%----------------------%
% Objective
%----------------------%
solve minimize totalCost;

%----------------------%
% Output
%----------------------%
output [
  "crop = ", show(crop), "\n",
  "area = ", show(area), "\n",
  "acresCorn = ", show(acresCorn), "\n",
  "acresWheat = ", show(acresWheat), "\n",
  "acresSoybean = ", show(acresSoy), "\n",
  "acresRice = ", show(acresRice), "\n",
  "totalCost = ", show(totalCost), "\n"
];