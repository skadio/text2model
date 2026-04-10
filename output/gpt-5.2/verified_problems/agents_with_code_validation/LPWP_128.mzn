% Parameters
int: WaterPerLiquid;     % Water required per liquid sanitizer
int: AlcoholPerLiquid;   % Alcohol required per liquid sanitizer
int: WaterPerFoam;       % Water required per foam sanitizer
int: AlcoholPerFoam;     % Alcohol required per foam sanitizer
int: TotalWater;         % Total available water
int: TotalAlcohol;       % Total available alcohol
int: HandsPerLiquid;     % Hands cleaned per liquid sanitizer
int: HandsPerFoam;       % Hands cleaned per foam sanitizer
int: MaxLiquid;          % Maximum number of liquid sanitizers allowed

% Variables
var 0..MaxLiquid: LiquidSanitizers;                       % Number of liquid sanitizers to produce
var 0..(TotalWater div WaterPerFoam): FoamSanitizers;     % Number of foam sanitizers to produce (water-based upper bound)

% Constraints
% Optional additional bounding constraint (kept separate for safety/clarity)
constraint FoamSanitizers <= TotalAlcohol div AlcoholPerFoam; % alcohol-based upper bound

% --- Resource capacity constraints (do not exceed available ingredients) ---
constraint
  WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;

constraint
  AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

% --- Production relationship constraint (foam must exceed liquid) ---
constraint
  FoamSanitizers > LiquidSanitizers;

% --- Liquid production limit (redundant with variable domain, kept explicit for clarity) ---
constraint
  LiquidSanitizers <= MaxLiquid;

% Objective
solve maximize HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;