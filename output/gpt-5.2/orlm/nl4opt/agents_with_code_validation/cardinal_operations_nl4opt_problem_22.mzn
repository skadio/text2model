% Parameters
% Resource availability (embedded from the problem statement)
int: platinum_available = 450;
int: palladium_available = 390;

% Resource usage and conversion rates for each catalyst type
int: platinum_per_palladium_heavy = 15;
int: palladium_per_palladium_heavy = 25;
int: rate_palladium_heavy = 5;   % units converted per second

int: platinum_per_platinum_heavy = 20;
int: palladium_per_platinum_heavy = 14;
int: rate_platinum_heavy = 4;    % units converted per second


% Variables
% Number of each catalyst to use (nonnegative integers)
% Upper bounds derived from platinum availability (safe, may not be tight due to palladium constraint)
var 0..(platinum_available div platinum_per_palladium_heavy): x_palladium_heavy;
var 0..(platinum_available div platinum_per_platinum_heavy): x_platinum_heavy;

% Total conversion rate to maximize (bounded for safety)
var 0..(rate_palladium_heavy * (platinum_available div platinum_per_palladium_heavy)
      + rate_platinum_heavy  * (platinum_available div platinum_per_platinum_heavy)): total_converted_per_second;


% Constraints
% Do not exceed available platinum
constraint
  platinum_per_palladium_heavy * x_palladium_heavy
+ platinum_per_platinum_heavy  * x_platinum_heavy
<= platinum_available;

% Do not exceed available palladium
constraint
  palladium_per_palladium_heavy * x_palladium_heavy
+ palladium_per_platinum_heavy  * x_platinum_heavy
<= palladium_available;

% Total conversion rate definition
constraint
  total_converted_per_second =
    rate_palladium_heavy * x_palladium_heavy
  + rate_platinum_heavy  * x_platinum_heavy;


% Objective
solve maximize total_converted_per_second;