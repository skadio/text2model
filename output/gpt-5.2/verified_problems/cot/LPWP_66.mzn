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
var 0..(if ButterPerAlmond > 0 then TotalButter div ButterPerAlmond else TotalButter endif): AlmondCroissants;
var 0..(if ButterPerPistachio > 0 then TotalButter div ButterPerPistachio else TotalButter endif): PistachioCroissants;

% Constraints
constraint ButterPerAlmond >= 0 /\ ButterPerPistachio >= 0 /\
           FlourPerAlmond >= 0 /\ FlourPerPistachio >= 0 /\
           TotalButter >= 0 /\ TotalFlour >= 0 /\
           TimePerAlmond >= 0 /\ TimePerPistachio >= 0 /\
           MinAlmondRatio >= 0;

constraint ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter;
constraint FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour;

constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
solve minimize TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;