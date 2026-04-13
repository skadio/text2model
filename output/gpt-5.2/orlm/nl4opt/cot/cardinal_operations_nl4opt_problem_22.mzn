% Parameters (with values embedded)
int: platinum_available = 450;
int: palladium_available = 390;

int: platinum_palladium_heavy = 15;
int: palladium_palladium_heavy = 25;
int: rate_palladium_heavy = 5;

int: platinum_platinum_heavy = 20;
int: palladium_platinum_heavy = 14;
int: rate_platinum_heavy = 4;

% Variables
var 0..(platinum_available div platinum_palladium_heavy): x_palladium_heavy; % number of palladium-heavy catalysts
var 0..(platinum_available div platinum_platinum_heavy): x_platinum_heavy;  % number of platinum-heavy catalysts

% Constraints
constraint
  platinum_palladium_heavy * x_palladium_heavy +
  platinum_platinum_heavy * x_platinum_heavy
  <= platinum_available;

constraint
  palladium_palladium_heavy * x_palladium_heavy +
  palladium_platinum_heavy * x_platinum_heavy
  <= palladium_available;

% Objective
var int: total_converted_per_second =
  rate_palladium_heavy * x_palladium_heavy +
  rate_platinum_heavy * x_platinum_heavy;

solve maximize total_converted_per_second;

output [
  "palladium_heavy=", show(x_palladium_heavy), "\n",
  "platinum_heavy=", show(x_platinum_heavy), "\n",
  "total_converted_per_second=", show(total_converted_per_second), "\n"
];