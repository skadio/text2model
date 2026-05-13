% Parameters
int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

% Variables
var 0..TotalButter: AlmondCroissants;
var 0..TotalButter: PistachioCroissants;

% Constraints
constraint ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter;
constraint FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour;
constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
solve minimize TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;