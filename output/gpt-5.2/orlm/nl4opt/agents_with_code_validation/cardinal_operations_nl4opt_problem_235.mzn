% Parameters
% Nutrient content per kg for each fertilizer (A,B)
set of int: F = 1..2; % 1=A, 2=B

array[F] of int: nitrogen_per_kg   = [13, 8];
array[F] of int: phosphoric_per_kg = [5, 14];
array[F] of int: vitaminA_per_kg   = [6, 6];
array[F] of int: vitaminD_per_kg   = [5, 9];

% Requirements / limits
int: min_nitrogen   = 220;
int: min_phosphoric = 160;
int: max_vitaminA   = 350;

% Variables
% Amount (kg) of each fertilizer to use (non-negative).
% Upper bound from vitamin A cap: 6*(kgA+kgB) <= 350 => kgA+kgB <= 58 (350/6).
array[F] of var 0..350: kg;

% Total vitamin D in the blend (objective value)
var 0..(9*350): total_vitaminD;

% Constraints

% --- Nutrient minimum requirements (effectiveness) ---
constraint sum(f in F)(nitrogen_per_kg[f] * kg[f]) >= min_nitrogen;
constraint sum(f in F)(phosphoric_per_kg[f] * kg[f]) >= min_phosphoric;

% --- Nutrient maximum limit (safety/quality cap) ---
constraint sum(f in F)(vitaminA_per_kg[f] * kg[f]) <= max_vitaminA;

% --- Define total vitamin D (objective expression linkage) ---
constraint total_vitaminD = sum(f in F)(vitaminD_per_kg[f] * kg[f]);

% Objective
solve minimize total_vitaminD;