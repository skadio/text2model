% ============================================================
% Bakery Production Optimization - MiniZinc Model
% ============================================================

% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: ButterPerAlmond;
int: ButterPerPistachio;
int: FlourPerAlmond;
int: FlourPerPistachio;

int: TotalButter;
int: TotalFlour;

int: TimePerAlmond;
int: TimePerPistachio;

int: MinAlmondRatio;

% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

var 0..TotalButter div ButterPerAlmond: AlmondCroissants;
var 0..TotalButter div ButterPerPistachio: PistachioCroissants;
var int: TotalTime;

% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Butter Constraint: Total butter used must not exceed available butter
constraint
    AlmondCroissants * ButterPerAlmond + PistachioCroissants * ButterPerPistachio <= TotalButter;

% (C2) Flour Constraint: Total flour used must not exceed available flour
constraint
    AlmondCroissants * FlourPerAlmond + PistachioCroissants * FlourPerPistachio <= TotalFlour;

% (C3) Production Ratio: Almond croissants must be at least MinAlmondRatio times pistachio croissants
constraint
    AlmondCroissants >= MinAlmondRatio * PistachioCroissants;

% (C4) Total Production Time Calculation
constraint
    TotalTime = AlmondCroissants * TimePerAlmond + PistachioCroissants * TimePerPistachio;

% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------

solve minimize TotalTime;

% -----------------------------
% 5) OUTPUT
% -----------------------------

output [
    "Optimal Production Plan:\n",
    "  Almond Croissants: ", show(AlmondCroissants), "\n",
    "  Pistachio Croissants: ", show(PistachioCroissants), "\n",
    "  Total Baking Time: ", show(TotalTime), "\n"
];