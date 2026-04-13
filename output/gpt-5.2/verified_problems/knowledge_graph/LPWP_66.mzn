int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

var 0..TotalButter div min(ButterPerAlmond, ButterPerPistachio): AlmondCroissants;
var 0..TotalButter div min(ButterPerAlmond, ButterPerPistachio): PistachioCroissants;

constraint
  ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter;

constraint
  FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour;

constraint
  AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

var int: TotalTime = TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;

solve minimize TotalTime;

output [
  "AlmondCroissants=", show(AlmondCroissants), "\n",
  "PistachioCroissants=", show(PistachioCroissants), "\n",
  "TotalTime=", show(TotalTime), "\n"
];