% ============================================================
% HAND SANITIZER PRODUCTION OPTIMIZATION MODEL
% ============================================================
%
% PROBLEM DESCRIPTION:
% -------------------
% A company manufactures liquid and foam hand sanitizers, both of which require
% water and alcohol as key ingredients. Each sanitizer type can clean a certain
% number of hands, and there are constraints on production.
%
% - Each sanitizer requires a fixed amount of water and alcohol.
% - The total available water and alcohol limit production.
% - More foam sanitizers must be produced than liquid sanitizers.
% - Liquid sanitizers have a production cap.
%
% OBJECTIVE:
% ----------
% Find the optimal number of liquid and foam sanitizers to produce to **maximize**
% the total number of hands that can be cleaned while staying within the resource limits.
%
% PARAMETERS PROVIDED IN JSON:
% {
%   "TotalWater": <int>, "TotalAlcohol": <int>,
%   "WaterPerLiquid": <int>, "AlcoholPerLiquid": <int>,
%   "WaterPerFoam": <int>, "AlcoholPerFoam": <int>,
%   "HandsPerLiquid": <int>, "HandsPerFoam": <int>,
%   "MaxLiquid": <int>
% }
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: TotalWater;      % Total available water
int: TotalAlcohol;    % Total available alcohol

int: WaterPerLiquid;  % Water required per liquid sanitizer
int: AlcoholPerLiquid;% Alcohol required per liquid sanitizer
int: WaterPerFoam;    % Water required per foam sanitizer
int: AlcoholPerFoam;  % Alcohol required per foam sanitizer

int: HandsPerLiquid;  % Cleaning capacity per liquid sanitizer
int: HandsPerFoam;    % Cleaning capacity per foam sanitizer

int: MaxLiquid;       % Maximum number of liquid sanitizers


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

% The number of liquid and foam sanitizers to produce
var 0..MaxLiquid: LiquidSanitizers;
var 0..TotalWater div WaterPerFoam: FoamSanitizers;

% The total number of hands that can be cleaned
var int: TotalHandsCleaned;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Water Constraint: The total water used cannot exceed available supply.
constraint
    LiquidSanitizers * WaterPerLiquid + FoamSanitizers * WaterPerFoam <= TotalWater;

% (C2) Alcohol Constraint: The total alcohol used cannot exceed available supply.
constraint
    LiquidSanitizers * AlcoholPerLiquid + FoamSanitizers * AlcoholPerFoam <= TotalAlcohol;

% (C3) Production Constraint: More foam sanitizers must be produced than liquid sanitizers.
constraint
    FoamSanitizers > LiquidSanitizers;

% (C4) Total Hands Calculation:
% The total number of hands cleaned is the sum from both types of sanitizers.
constraint
    TotalHandsCleaned = LiquidSanitizers * HandsPerLiquid + FoamSanitizers * HandsPerFoam;


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------

% Maximize the total number of hands cleaned.
solve maximize TotalHandsCleaned;


% -----------------------------
% 5) OUTPUT
% -----------------------------

% Print the number of each sanitizer produced and the total hands cleaned.
output [
    "Optimal Sanitizer Production Plan:\n",
    "  Liquid Sanitizers Produced: ", show(LiquidSanitizers), "\n",
    "  Foam Sanitizers Produced: ", show(FoamSanitizers), "\n",
    "Maximum Hands Cleaned: ", show(TotalHandsCleaned), "\n"
];