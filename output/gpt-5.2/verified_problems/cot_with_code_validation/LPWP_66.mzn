% Parameters (to be provided in .dzn)
int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

% Decision variables
var 0..(TotalButter div ButterPerAlmond): AlmondCroissants;
var 0..(TotalButter div ButterPerPistachio): PistachioCroissants;

% Total time (objective)
var 0..(TimePerAlmond * (TotalButter div ButterPerAlmond)
      + TimePerPistachio * (TotalButter div ButterPerPistachio)): TotalTime;

% Constraints
constraint ButterPerAlmond * AlmondCroissants
         + ButterPerPistachio * PistachioCroissants <= TotalButter;

constraint FlourPerAlmond * AlmondCroissants
         + FlourPerPistachio * PistachioCroissants <= TotalFlour;

constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

constraint TotalTime = TimePerAlmond * AlmondCroissants
                     + TimePerPistachio * PistachioCroissants;

% Objective
solve minimize TotalTime;

output [
  "AlmondCroissants=", show(AlmondCroissants), "\n",
  "PistachioCroissants=", show(PistachioCroissants), "\n",
  "TotalTime=", show(TotalTime), "\n"
];