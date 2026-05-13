% --------------------------------------------------------------------
%  Croissant Production Optimisation
% --------------------------------------------------------------------
%  Decision variables
var int: AlmondCroissants  >= 0;   % number of almond croissants
var int: PistachioCroissants >= 0;  % number of pistachio croissants

%  Parameters (read from .dzn file)
int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

%  Constraints – ingredient limits
constraint ButterPerAlmond * AlmondCroissants
          + ButterPerPistachio * PistachioCroissants
          <= TotalButter;

constraint FlourPerAlmond * AlmondCroissants
          + FlourPerPistachio * PistachioCroissants
          <= TotalFlour;

%  Constraint – almond to pistachio ratio
constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

%  Objective – minimise total baking time
var int: TotalTime = TimePerAlmond * AlmondCroissants
                    + TimePerPistachio * PistachioCroissants;

solve minimize TotalTime;

%  Output
output [
  "Almond croissants  = ", show(AlmondCroissants), "\n",
  "Pistachio croissants = ", show(PistachioCroissants), "\n",
  "Total baking time   = ", show(TotalTime), " minutes\n"
];