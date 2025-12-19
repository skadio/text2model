% Parameters (provided in the .dzn file)
int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;
int: TotalButter;
int: TotalFlour;
int: TimePerAlmond;
int: TimePerPistachio;
int: MinAlmondRatio;

% Decision variables: number of croissants to produce (nonnegative integers)
% Upper bounds are estimated from available ingredients.
var 0..TotalButter div ButterPerAlmond: AlmondCroissants;
var 0..TotalButter div ButterPerPistachio: PistachioCroissants;

% Ingredient constraints:
constraint AlmondCroissants * ButterPerAlmond + PistachioCroissants * ButterPerPistachio <= TotalButter;
constraint AlmondCroissants * FlourPerAlmond + PistachioCroissants * FlourPerPistachio <= TotalFlour;

% Production ratio constraint: almond croissants must be at least MinAlmondRatio times pistachio croissants.
constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% Define total baking time objective.
var int: TotalBakingTime = AlmondCroissants * TimePerAlmond + PistachioCroissants * TimePerPistachio;

solve
    minimize TotalBakingTime;

output [
    "AlmondCroissants = ", show(AlmondCroissants), "\n",
    "PistachioCroissants = ", show(PistachioCroissants), "\n",
    "Total Baking Time = ", show(TotalBakingTime), "\n"
];