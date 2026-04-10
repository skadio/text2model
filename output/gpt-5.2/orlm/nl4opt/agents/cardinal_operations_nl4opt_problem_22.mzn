% Parameters
int: platinum_per_palladium_heavy = 15;     % Platinum units needed per palladium-heavy catalyst
int: palladium_per_palladium_heavy = 25;    % Palladium units needed per palladium-heavy catalyst
int: rate_palladium_heavy = 5;              % Conversion rate (units/sec) for palladium-heavy catalyst

int: platinum_per_platinum_heavy = 20;      % Platinum units needed per platinum-heavy catalyst
int: palladium_per_platinum_heavy = 14;     % Palladium units needed per platinum-heavy catalyst
int: rate_platinum_heavy = 4;               % Conversion rate (units/sec) for platinum-heavy catalyst

int: platinum_available = 450;              % Total available platinum units
int: palladium_available = 390;             % Total available palladium units

% Upper bounds derived from resource limits (safe integer bounds)
int: max_palladium_heavy =
  min(platinum_available div platinum_per_palladium_heavy,
      palladium_available div palladium_per_palladium_heavy);

int: max_platinum_heavy =
  min(platinum_available div platinum_per_platinum_heavy,
      palladium_available div palladium_per_platinum_heavy);


% Variables
var 0..max_palladium_heavy: num_palladium_heavy;   % Number of palladium-heavy catalysts to use
var 0..max_platinum_heavy: num_platinum_heavy;     % Number of platinum-heavy catalysts to use

var 0..(rate_palladium_heavy*max_palladium_heavy + rate_platinum_heavy*max_platinum_heavy):
  total_conversion_rate;                            % Total conversion rate (units/sec)


% Constraints

% Resource limit: total platinum used by both catalyst types cannot exceed availability
constraint
  platinum_per_palladium_heavy * num_palladium_heavy
+ platinum_per_platinum_heavy  * num_platinum_heavy
<= platinum_available;

% Resource limit: total palladium used by both catalyst types cannot exceed availability
constraint
  palladium_per_palladium_heavy * num_palladium_heavy
+ palladium_per_platinum_heavy  * num_platinum_heavy
<= palladium_available;

% Define total conversion rate from the chosen numbers of catalysts
constraint
  total_conversion_rate =
    rate_palladium_heavy * num_palladium_heavy
  + rate_platinum_heavy  * num_platinum_heavy;


% Objective
solve maximize total_conversion_rate;

output [
  "num_palladium_heavy=", show(num_palladium_heavy), "\n",
  "num_platinum_heavy=", show(num_platinum_heavy), "\n",
  "total_conversion_rate=", show(total_conversion_rate), "\n"
];