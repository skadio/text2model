% Croissant production optimization (minimize total baking time)

% Parameters (provided in .dzn)
int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

% Decision variables (may be pre-sized in .dzn; otherwise remain free nonnegative integers)
var int: AlmondCroissants;
var int: PistachioCroissants;

% Basic feasibility domains (nonnegative)
constraint AlmondCroissants >= 0;
constraint PistachioCroissants >= 0;

% Ingredient constraints
constraint ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter;
constraint FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour;

% Popularity/rationing constraint: almond at least MinAlmondRatio times pistachio
constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective: minimize total baking time
var int: TotalTime = TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;

solve minimize TotalTime;

output [
  "AlmondCroissants = ", show(AlmondCroissants), ";\n",
  "PistachioCroissants = ", show(PistachioCroissants), ";\n",
  "TotalTime = ", show(TotalTime), ";\n"
];