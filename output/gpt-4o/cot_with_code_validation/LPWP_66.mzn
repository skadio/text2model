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

% Derived upper bounds to keep variables finite
int: MaxAlmondByButter  = TotalButter div ButterPerAlmond;
int: MaxAlmondByFlour   = TotalFlour  div FlourPerAlmond;
int: MaxAlmond          = min(MaxAlmondByButter, MaxAlmondByFlour);

int: MaxPistByButter    = TotalButter div ButterPerPistachio;
int: MaxPistByFlour     = TotalFlour  div FlourPerPistachio;
int: MaxPistachio       = min(MaxPistByButter, MaxPistByFlour);

% Variables
var 0..MaxAlmond    : AlmondCroissants;
var 0..MaxPistachio : PistachioCroissants;

% Constraints
constraint
    AlmondCroissants * ButterPerAlmond +
    PistachioCroissants * ButterPerPistachio <= TotalButter;

constraint
    AlmondCroissants * FlourPerAlmond +
    PistachioCroissants * FlourPerPistachio <= TotalFlour;

constraint
    AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
solve maximize AlmondCroissants + PistachioCroissants;