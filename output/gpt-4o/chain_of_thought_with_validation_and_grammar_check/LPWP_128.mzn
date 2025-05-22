% Parameters
int: WaterPerLiquid;
int: AlcoholPerLiquid;
int: WaterPerFoam;
int: AlcoholPerFoam;
int: TotalWater;
int: TotalAlcohol;
int: HandsPerLiquid;
int: HandsPerFoam;
int: MaxLiquid;

% Upper bound on foam sanitizers based on available resources
int: MaxFoam = min(TotalWater div WaterPerFoam, TotalAlcohol div AlcoholPerFoam);

% Variables
var 0..MaxLiquid: LiquidSanitizers;
var 0..MaxFoam:  FoamSanitizers;

% Constraints
constraint LiquidSanitizers <= MaxLiquid;

constraint FoamSanitizers > LiquidSanitizers;

constraint
  LiquidSanitizers * WaterPerLiquid +
  FoamSanitizers    * WaterPerFoam   <= TotalWater;

constraint
  LiquidSanitizers * AlcoholPerLiquid +
  FoamSanitizers    * AlcoholPerFoam  <= TotalAlcohol;

% Objective
solve maximize
  HandsPerLiquid * LiquidSanitizers +
  HandsPerFoam   * FoamSanitizers;