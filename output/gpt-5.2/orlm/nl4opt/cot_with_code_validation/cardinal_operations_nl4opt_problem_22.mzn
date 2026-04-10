% Parameters
int: platinum_available = 450;
int: palladium_available = 390;

int: platinum_palladium_heavy = 15;
int: palladium_palladium_heavy = 25;
int: rate_palladium_heavy = 5;

int: platinum_platinum_heavy = 20;
int: palladium_platinum_heavy = 14;
int: rate_platinum_heavy = 4;

% Variables
var 0..(platinum_available div platinum_palladium_heavy): x_palladium_heavy;
var 0..(platinum_available div platinum_platinum_heavy): x_platinum_heavy;

var 0..(rate_palladium_heavy * (platinum_available div platinum_palladium_heavy) +
        rate_platinum_heavy * (platinum_available div platinum_platinum_heavy)): total_converted_rate;

% Constraints
constraint
  platinum_palladium_heavy * x_palladium_heavy + platinum_platinum_heavy * x_platinum_heavy
  <= platinum_available;

constraint
  palladium_palladium_heavy * x_palladium_heavy + palladium_platinum_heavy * x_platinum_heavy
  <= palladium_available;

constraint
  total_converted_rate = rate_palladium_heavy * x_palladium_heavy + rate_platinum_heavy * x_platinum_heavy;

% Objective
solve maximize total_converted_rate;