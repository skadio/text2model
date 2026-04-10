% Parameters
int: total_resin = 3000;                 % Total available resin (units)

int: resin_per_molar = 20;               % Resin needed per molar cavity
float: pain_per_molar = 3.0;             % Pain killer needed per molar cavity

int: resin_per_canine = 15;              % Resin needed per canine cavity
float: pain_per_canine = 2.3;            % Pain killer needed per canine cavity

float: min_canine_fraction = 0.60;       % At least this fraction of filled cavities are canines
int: min_molars = 45;                    % Must fill at least this many molars

% Variables
var min_molars..(total_resin div resin_per_molar): molars;  % Number of molar cavities to fill
var 0..(total_resin div resin_per_canine): canines;         % Number of canine cavities to fill

var 0.0..(pain_per_molar * float(total_resin div resin_per_molar)
        + pain_per_canine * float(total_resin div resin_per_canine)): total_pain;
        % Total pain killer used

% Constraints
% Resin capacity constraint: total resin used cannot exceed available resin
constraint
    resin_per_molar * molars + resin_per_canine * canines <= total_resin;

% Minimum molars requirement
constraint
    molars >= min_molars;

% Canine fraction constraint (avoid division/coercion issues)
% canines / (molars + canines) >= min_canine_fraction
constraint
    float(canines) >= min_canine_fraction * (float(molars) + float(canines));

% Define total pain killer used
constraint
    total_pain = pain_per_molar * float(molars) + pain_per_canine * float(canines);

% Objective
solve minimize total_pain;