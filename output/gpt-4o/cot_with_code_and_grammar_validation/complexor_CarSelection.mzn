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

% Derived upper-bounds for tighter variable domains
int: MaxAlmond_ByButter = TotalButter div ButterPerAlmond;
int: MaxAlmond_ByFlour  = TotalFlour  div FlourPerAlmond;
int: MaxAlmond          = min(MaxAlmond_ByButter, MaxAlmond_ByFlour);

int: MaxPist_ByButter = TotalButter div ButterPerPistachio;
int: MaxPist_ByFlour  = TotalFlour  div FlourPerPistachio;
int: MaxPistachio     = min(MaxPist_ByButter, MaxPist_ByFlour);

% Variables
var 0..MaxAlmond:     AlmondCroissants;
var 0..MaxPistachio:  PistachioCroissants;

% Constraints
constraint 
    ButterPerAlmond   * AlmondCroissants +
    ButterPerPistachio* PistachioCroissants <= TotalButter;

constraint 
    FlourPerAlmond    * AlmondCroissants +
    FlourPerPistachio * PistachioCroissants <= TotalFlour;

constraint 
    AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
solve minimize
    TimePerAlmond   * AlmondCroissants +
    TimePerPistachio* PistachioCroissants;