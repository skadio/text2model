% Parameters
% Total available land (square miles)
int: total_land = 100;

% Number of mining techniques
int: n_techniques = 2;
set of int: TECH = 1..n_techniques;

% Technique indices (for readability)
int: HEAP = 1;
int: VAT  = 2;

% Daily production (tons of rare earth oxide) per square mile by technique
array[TECH] of int: prod_per_sqmi = [3, 5];

% Polluted wastewater (tons) per square mile by technique
array[TECH] of int: wastewater_per_sqmi = [8, 17];

% Machines required per square mile by technique
array[TECH] of int: machines_per_sqmi = [10, 20];

% Resource limits
int: max_machines = 100;
int: max_wastewater = 90;


% Variables
% Land allocated to each technique (square miles)
array[TECH] of var 0..total_land: land_sqmi;

% Proportion of total land allocated to each technique (0..1)
array[TECH] of var 0.0..1.0: proportion;

% Total daily production (tons)
var 0..(total_land * max(prod_per_sqmi)): total_production;

% Total daily polluted wastewater (tons)
var 0..(total_land * max(wastewater_per_sqmi)): total_wastewater;

% Total machines used
var 0..(total_land * max(machines_per_sqmi)): total_machines;


% Constraints
% --- Land allocation consistency ---
% All available land must be allocated across the two techniques.
constraint sum(t in TECH)(land_sqmi[t]) = total_land;

% --- Proportion definition and consistency ---
% NOTE: land_sqmi is integer; division yields float, so coerce land_sqmi to float.
constraint
  forall(t in TECH) (
    proportion[t] = int2float(land_sqmi[t]) / int2float(total_land)
  );

% Proportions must sum to 1 (redundant with land sum, but strengthens model).
constraint sum(t in TECH)(proportion[t]) = 1.0;

% --- Total production calculation ---
constraint
  total_production = sum(t in TECH)(prod_per_sqmi[t] * land_sqmi[t]);

% --- Total wastewater calculation and environmental limit ---
constraint
  total_wastewater = sum(t in TECH)(wastewater_per_sqmi[t] * land_sqmi[t]);
constraint total_wastewater <= max_wastewater;

% --- Total machines calculation and capacity limit ---
constraint
  total_machines = sum(t in TECH)(machines_per_sqmi[t] * land_sqmi[t]);
constraint total_machines <= max_machines;


% Objective
solve maximize total_production;