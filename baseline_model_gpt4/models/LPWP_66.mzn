% Variables
var 0..TotalButter div ButterPerAlmond: AlmondCroissants;
var 0..TotalButter div ButterPerPistachio: PistachioCroissants;

% Constraints
constraint AlmondCroissants * ButterPerAlmond + PistachioCroissants * ButterPerPistachio <= TotalButter;
constraint AlmondCroissants * FlourPerAlmond + PistachioCroissants * FlourPerPistachio <= TotalFlour;
constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
var int: TotalTime = AlmondCroissants * TimePerAlmond + PistachioCroissants * TimePerPistachio;
solve minimize TotalTime;

% Output
output ["Almond Croissants: ", show(AlmondCroissants), "\nPistachio Croissants: ", show(PistachioCroissants), "\nTotal Baking Time: ", show(TotalTime)];