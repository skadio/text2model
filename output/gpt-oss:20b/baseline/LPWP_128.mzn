var int: LiquidSanitizers;
var int: FoamSanitizers;

constraint LiquidSanitizers >= 0;
constraint FoamSanitizers >= 0;

constraint FoamSanitizers > LiquidSanitizers;
constraint LiquidSanitizers <= MaxLiquid;

constraint LiquidSanitizers * WaterPerLiquid + FoamSanitizers * WaterPerFoam <= TotalWater;
constraint LiquidSanitizers * AlcoholPerLiquid + FoamSanitizers * AlcoholPerFoam <= TotalAlcohol;

solve maximize LiquidSanitizers * HandsPerLiquid + FoamSanitizers * HandsPerFoam;

output [
    "LiquidSanitizers = ", show(LiquidSanitizers), "\n",
    "FoamSanitizers = ", show(FoamSanitizers), "\n",
    "TotalHandsCleaned = ", show(LiquidSanitizers * HandsPerLiquid + FoamSanitizers * HandsPerFoam), "\n"
];