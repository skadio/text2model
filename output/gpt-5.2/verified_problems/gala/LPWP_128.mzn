% Hand Sanitizer Production Optimization

% Input data (provided in .dzn)
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
% Upper bound for foam derived from resources (safe, finite)
int: FoamUB =
  min( if WaterPerFoam > 0 then TotalWater div WaterPerFoam else TotalWater endif,
       if AlcoholPerFoam > 0 then TotalAlcohol div AlcoholPerFoam else TotalAlcohol endif );
var 0..FoamUB: FoamSanitizers;

% Resource constraints
constraint WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

% Business constraints
constraint FoamSanitizers > LiquidSanitizers;
constraint LiquidSanitizers <= MaxLiquid;

% Objective: maximize hands cleaned
var int: TotalHands = HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;

solve maximize TotalHands;

output [
  "LiquidSanitizers = ", show(LiquidSanitizers), "\n",
  "FoamSanitizers   = ", show(FoamSanitizers), "\n",
  "TotalHands       = ", show(TotalHands), "\n"
];