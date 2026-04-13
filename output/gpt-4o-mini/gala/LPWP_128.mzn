int: LiquidSanitizers;          % Number of liquid hand sanitizers to produce
int: FoamSanitizers;            % Number of foam hand sanitizers to produce
int: WaterPerLiquid;            % Water required per liquid sanitizer
int: AlcoholPerLiquid;          % Alcohol required per liquid sanitizer
int: WaterPerFoam;              % Water required per foam sanitizer
int: AlcoholPerFoam;            % Alcohol required per foam sanitizer
int: TotalWater;                % Total available water
int: TotalAlcohol;              % Total available alcohol
int: HandsPerLiquid;            % Cleaning capacity per liquid sanitizer
int: HandsPerFoam;              % Cleaning capacity per foam sanitizer
int: MaxLiquid;                 % Maximum number of liquid sanitizers

/* Variables */
var 0..MaxLiquid: liquid;      % Number of liquid sanitizers produced
var 0..TotalAlcohol div AlcoholPerFoam: foam; % Number of foam sanitizers produced
var 0..TotalWater div WaterPerLiquid: totalHands; % Total hands cleaned

/* Constraints */
constraint liquid <= MaxLiquid; % Limit on liquid sanitizers
constraint foam > liquid;        % More foam than liquid sanitizers

constraint (WaterPerLiquid * liquid + WaterPerFoam * foam) <= TotalWater; % Water constraint
constraint (AlcoholPerLiquid * liquid + AlcoholPerFoam * foam) <= TotalAlcohol; % Alcohol constraint

/* Objective */
var int: totalHands = HandsPerLiquid * liquid + HandsPerFoam * foam; % Total hands cleaned
solve maximize totalHands;

/* Output */
output [ "Liquid Sanitizers: ", show(liquid), "\nFoam Sanitizers: ", show(foam), "\nTotal Hands Cleaned: ", show(totalHands), "\n" ];