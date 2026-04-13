% Parameters
int: WaterPerLiquid;     % Water required per liquid sanitizer
int: AlcoholPerLiquid;   % Alcohol required per liquid sanitizer
int: WaterPerFoam;       % Water required per foam sanitizer
int: AlcoholPerFoam;     % Alcohol required per foam sanitizer

int: TotalWater;         % Total available water
int: TotalAlcohol;       % Total available alcohol

int: HandsPerLiquid;     % Hands cleaned per liquid sanitizer
int: HandsPerFoam;       % Hands cleaned per foam sanitizer

int: MaxLiquid;          % Maximum allowed number of liquid sanitizers

% Variables
var 0..MaxLiquid: LiquidSanitizers; % Number of liquid sanitizers to produce
var 0..TotalWater: FoamSanitizers;  % Upper bound is safe; further tightened by constraints below

% Constraints
% --- Resource capacity constraints (water and alcohol) ---
constraint
  WaterPerLiquid * LiquidSanitizers + WaterPerFoam * FoamSanitizers <= TotalWater;
constraint
  AlcoholPerLiquid * LiquidSanitizers + AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

% --- Production policy constraints ---
% Must produce more foam sanitizers than liquid sanitizers
constraint
  FoamSanitizers > LiquidSanitizers;

% Liquid production is limited by MaxLiquid (already enforced by variable domain, repeated for clarity)
constraint
  LiquidSanitizers <= MaxLiquid;

% --- Domain tightening for FoamSanitizers based on resources (optional but useful) ---
constraint
  WaterPerFoam * FoamSanitizers <= TotalWater;
constraint
  AlcoholPerFoam * FoamSanitizers <= TotalAlcohol;

% Objective
solve maximize HandsPerLiquid * LiquidSanitizers + HandsPerFoam * FoamSanitizers;