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

% Upper-bound helpers (computed from available resources)
int: UB_Almond    = min(TotalButter div ButterPerAlmond , TotalFlour div FlourPerAlmond );
int: UB_Pistachio = min(TotalButter div ButterPerPistachio , TotalFlour div FlourPerPistachio);

% Variables
var 0..UB_Almond   : AlmondCroissants;
var 0..UB_Pistachio: PistachioCroissants;

% Constraints
constraint ButterPerAlmond  * AlmondCroissants
        + ButterPerPistachio * PistachioCroissants
        <= TotalButter;

constraint FlourPerAlmond  * AlmondCroissants
        + FlourPerPistachio * PistachioCroissants
        <= TotalFlour;

constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Objective
solve minimize
       TimePerAlmond  * AlmondCroissants
     + TimePerPistachio * PistachioCroissants;