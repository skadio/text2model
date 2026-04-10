% Parameters
% Time (minutes) for one unit of each chemical to be effective
int: time_chlorine = 1;
int: time_softener = 2;

% Requirements / limits
int: min_chlorine_units = 200;     % at least this many units of chlorine
int: total_chemical_units = 500;   % total units of chemicals (chlorine + softener)

% Ratio constraint: chlorine <= 0.5 * softener  <=>  2*chlorine <= softener
int: chlorine_ratio_num = 2;       % multiplier for chlorine
int: chlorine_ratio_den = 1;       % multiplier for softener (kept as ints for linearity)

% Variables
var 0..total_chemical_units: chlorine_units;  % units of chlorine to add
var 0..total_chemical_units: softener_units;  % units of water softener to add

% Total time in minutes (objective variable)
var 0..(time_chlorine * total_chemical_units + time_softener * total_chemical_units): total_time;

% Constraints
%--- Chemical quantity requirements ---
constraint chlorine_units >= min_chlorine_units;
constraint chlorine_units + softener_units = total_chemical_units;

%--- Safety ratio constraint (limit chlorine relative to softener) ---
constraint chlorine_ratio_num * chlorine_units <= chlorine_ratio_den * softener_units;

%--- Total time definition ---
constraint total_time =
  time_chlorine * chlorine_units + time_softener * softener_units;

% Objective
solve minimize total_time;

% Optional output
output [
  "chlorine_units = ", show(chlorine_units), "\n",
  "softener_units = ", show(softener_units), "\n",
  "total_time = ", show(total_time), "\n"
];