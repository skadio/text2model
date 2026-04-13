% Parameters
int: cap_large = 25;          % kg per large bag
int: cap_tiny  = 6;           % kg per tiny bag
int: energy_budget2 = 220;    % 2 * 110 to avoid decimals
int: energy_large2 = 8;       % 2 * 4
int: energy_tiny2  = 3;       % 2 * 1.5
int: min_tiny = 20;

% Variables
var 0..energy_budget2 div energy_large2: n_large;
var min_tiny..energy_budget2 div energy_tiny2: n_tiny;

% Constraints
constraint energy_large2 * n_large + energy_tiny2 * n_tiny <= energy_budget2;

% twice as many large as tiny
constraint n_large = 2 * n_tiny;

% Objective
var int: total_kg = cap_large * n_large + cap_tiny * n_tiny;
solve maximize total_kg;