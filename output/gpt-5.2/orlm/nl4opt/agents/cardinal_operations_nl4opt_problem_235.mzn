% Parameters
int: n_fert = 2;                       % Number of fertilizers (A,B)
set of int: FERT = 1..n_fert;          % Fertilizer index set

% Nutrient content per kg for each fertilizer
array[FERT] of int: nitrogen_per_kg   = [13, 8];
array[FERT] of int: phosphoric_per_kg = [5, 14];
array[FERT] of int: vitaminA_per_kg   = [6, 6];
array[FERT] of int: vitaminD_per_kg   = [5, 9];

% Requirements / limits
int: min_nitrogen   = 220;
int: min_phosphoric = 160;
int: max_vitaminA   = 350;

% Simple safe upper bound for kg amounts (keeps variables bounded)
int: max_kg = max(
  ceil(min_nitrogen / min(nitrogen_per_kg)),
  ceil(min_phosphoric / min(phosphoric_per_kg))
);

% Variables
array[FERT] of var 0..max_kg: kg;      % kg[1]=A, kg[2]=B
var 0..(max_kg * max(vitaminD_per_kg)): total_vitaminD;  % Total vitamin D in the mixture

% Constraints
% --- Total vitamin D definition ---
constraint
  total_vitaminD = sum(f in FERT)(vitaminD_per_kg[f] * kg[f]);

% --- Minimum nitrogen requirement ---
constraint
  sum(f in FERT)(nitrogen_per_kg[f] * kg[f]) >= min_nitrogen;

% --- Minimum phosphoric acid requirement ---
constraint
  sum(f in FERT)(phosphoric_per_kg[f] * kg[f]) >= min_phosphoric;

% --- Maximum vitamin A limit ---
constraint
  sum(f in FERT)(vitaminA_per_kg[f] * kg[f]) <= max_vitaminA;

% Objective
solve minimize total_vitaminD;