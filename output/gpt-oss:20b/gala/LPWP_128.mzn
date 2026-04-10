%--------------------  MiniZinc model  --------------------
int: WaterPerLiquid;
int: AlcoholPerLiquid;
int: WaterPerFoam;
int: AlcoholPerFoam;
int: TotalWater;
int: TotalAlcohol;
int: HandsPerLiquid;
int: HandsPerFoam;
int: MaxLiquid;

% Decision variables
var 0..MaxLiquid: LiquidSanitizers;
var 0..(min(TotalWater div WaterPerFoam, TotalAlcohol div AlcoholPerFoam)) : FoamSanitizers;

% Constraints
constraint FoamSanitizers > LiquidSanitizers;
constraint LiquidSanitizers * WaterPerLiquid + FoamSanitizers * WaterPerFoam <= TotalWater;
constraint LiquidSanitizers * AlcoholPerLiquid + FoamSanitizers * AlcoholPerFoam <= TotalAlcohol;

% Objective: maximise the number of hands cleaned
var int: HandsCleaned = LiquidSanitizers * HandsPerLiquid + FoamSanitizers * HandsPerFoam;
solve maximize HandsCleaned;

% Output
output [
  "LiquidSanitizers = ", show(LiquidSanitizers), "\n",
  "FoamSanitizers   = ", show(FoamSanitizers),   "\n",
  "HandsCleaned     = ", show(HandsCleaned),     "\n"
];