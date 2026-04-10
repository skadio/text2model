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
var 0..(TotalButter div max(1, ButterPerAlmond)) : AlmondCroissants;
var 0..(TotalButter div max(1, ButterPerPistachio)) : PistachioCroissants;

var 0..(TimePerAlmond * (TotalButter div max(1, ButterPerAlmond)) + 
        TimePerPistachio * (TotalButter div max(1, ButterPerPistachio))) : TotalTime;

% Constraints
constraint ButterPerAlmond >= 0 /\ ButterPerPistachio >= 0;
constraint FlourPerAlmond >= 0 /\ FlourPerPistachio >= 0;
constraint TotalButter >= 0 /\ TotalFlour >= 0;
constraint TimePerAlmond >= 0 /\ TimePerPistachio >= 0;
constraint MinAlmondRatio >= 0;

constraint
  ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter;

constraint
  FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour;

constraint
  AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

constraint
  TotalTime = TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;

% Objective
solve minimize TotalTime;