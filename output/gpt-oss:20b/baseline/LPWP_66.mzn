var int: AlmondCroissants;
var int: PistachioCroissants;

constraint AlmondCroissants >= 0;
constraint PistachioCroissants >= 0;

constraint ButterPerAlmond * AlmondCroissants + ButterPerPistachio * PistachioCroissants <= TotalButter;
constraint FlourPerAlmond * AlmondCroissants + FlourPerPistachio * PistachioCroissants <= TotalFlour;

constraint AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

solve minimize TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants;

output [
    "AlmondCroissants: ", show(AlmondCroissants), "\n",
    "PistachioCroissants: ", show(PistachioCroissants), "\n",
    "TotalTime: ", show(TimePerAlmond * AlmondCroissants + TimePerPistachio * PistachioCroissants)
];