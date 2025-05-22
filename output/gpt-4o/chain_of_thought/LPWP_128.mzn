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

/* Derived upper bound for foam sanitizers based on available resources */
int: MaxFoam = min(TotalWater div WaterPerFoam,
                   TotalAlcohol div AlcoholPerFoam);

% Variables
var 0..MaxLiquid: LiquidSanitizers;
var 0..MaxFoam:   FoamSanitizers;

% Constraints
constraint
    WaterPerLiquid * LiquidSanitizers +
    WaterPerFoam   * FoamSanitizers <= TotalWater;

constraint
    AlcoholPerLiquid * LiquidSanitizers +
    AlcoholPerFoam   * FoamSanitizers <= TotalAlcohol;

constraint
    FoamSanitizers > LiquidSanitizers;

% Objective
solve maximize
    HandsPerLiquid * LiquidSanitizers +
    HandsPerFoam   * FoamSanitizers;