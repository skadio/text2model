% Croissant production optimization (minimize total baking time)
% Data is provided via .dzn

int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

% If these are provided in the .dzn, they act as upper bounds (capacities) for search.
% If not provided, the model will compute safe upper bounds from ingredients.
int: AlmondCroissants = 0;
int: PistachioCroissants = 0;

% Safe computed upper bounds from ingredient limits (avoid division by 0)
int: maxA_butter = if ButterPerAlmond > 0 then TotalButter div ButterPerAlmond else 0 endif;
int: maxA_flour  = if FlourPerAlmond  > 0 then TotalFlour  div FlourPerAlmond  else 0 endif;
int: maxP_butter = if ButterPerPistachio > 0 then TotalButter div ButterPerPistachio else 0 endif;
int: maxP_flour  = if FlourPerPistachio  > 0 then TotalFlour  div FlourPerPistachio  else 0 endif;

int: maxA_ing = min(maxA_butter, maxA_flour);
int: maxP_ing = min(maxP_butter, maxP_flour);

int: maxA = if AlmondCroissants > 0 then AlmondCroissants else maxA_ing endif;
int: maxP = if PistachioCroissants > 0 then PistachioCroissants else maxP_ing endif;

var 0..maxA: A; % number of almond croissants
var 0..maxP: P; % number of pistachio croissants

% Ingredient constraints
constraint ButterPerAlmond * A + ButterPerPistachio * P <= TotalButter;
constraint FlourPerAlmond  * A + FlourPerPistachio  * P <= TotalFlour;

% Popularity / ratio constraint: A >= MinAlmondRatio * P
constraint A >= MinAlmondRatio * P;

% Objective: minimize total baking time
var int: TotalTime = TimePerAlmond * A + TimePerPistachio * P;

solve minimize TotalTime;

output [
  "AlmondCroissants = ", show(A), "\n",
  "PistachioCroissants = ", show(P), "\n",
  "TotalButterUsed = ", show(ButterPerAlmond * A + ButterPerPistachio * P), " / ", show(TotalButter), "\n",
  "TotalFlourUsed = ", show(FlourPerAlmond * A + FlourPerPistachio * P), " / ", show(TotalFlour), "\n",
  "TotalTime = ", show(TotalTime), "\n"
];