% Parameters
int: total_resin = 3000;                 % Total available resin units
int: resin_per_molar = 20;               % Resin units needed per molar filling
int: resin_per_canine = 15;              % Resin units needed per canine filling

float: painkiller_per_molar = 3.0;       % Pain killer units needed per molar filling
float: painkiller_per_canine = 2.3;      % Pain killer units needed per canine filling

float: min_canine_fraction = 0.60;       % At least this fraction of fillings must be canines
int: min_molars = 45;                    % Must be able to fill at least this many molars

% Derived upper bounds from resin availability
int: max_molars_by_resin = total_resin div resin_per_molar;    % 150
int: max_canines_by_resin = total_resin div resin_per_canine;  % 200


% Variables
var 0..max_molars_by_resin: molars;      % Number of molar cavities to fill
var 0..max_canines_by_resin: canines;    % Number of canine cavities to fill

var float: total_painkiller;             % Total pain killer used (objective value)


% Constraints
% Must reserve materials to fill at least 45 molars
constraint molars >= min_molars;

% Resin availability constraint
constraint resin_per_molar * molars + resin_per_canine * canines <= total_resin;

% At least 60% of fillings are canines:
% canines/(molars+canines) >= 0.60  <=>  2*canines >= 3*molars
% (uses an equivalent integer linear form to avoid float division)
constraint 2 * canines >= 3 * molars;

% Define objective expression
constraint total_painkiller =
    painkiller_per_molar * int2float(molars)
  + painkiller_per_canine * int2float(canines);


% Objective
solve minimize total_painkiller;