% Parameters
% Resource requirements per product (grams)
int: wood_per_elephant = 50;
int: plastic_per_elephant = 20;
int: wood_per_tiger = 40;
int: plastic_per_tiger = 30;

% Weekly available resources (grams)
int: wood_available = 5000;
int: plastic_available = 4000;

% Profit per unit ($)
int: profit_elephant = 5;
int: profit_tiger = 4;

% Upper bounds derived from resource limits (for bounded variable domains)
int: max_elephants = min(wood_available div wood_per_elephant,
                         plastic_available div plastic_per_elephant);
int: max_tigers = min(wood_available div wood_per_tiger,
                      plastic_available div plastic_per_tiger);

% Variables
% Number of elephants produced (non-negative integer)
var 0..max_elephants: elephants;

% Number of tigers produced (non-negative integer)
var 0..max_tigers: tigers;

% Total profit to maximize ($), explicitly bounded
var 0..(profit_elephant * max_elephants + profit_tiger * max_tigers): total_profit;

% Constraints
% Resource capacity constraints
constraint
  % Total wood used by elephants and tigers cannot exceed weekly wood availability
  wood_per_elephant * elephants + wood_per_tiger * tigers <= wood_available;

constraint
  % Total plastic used by elephants and tigers cannot exceed weekly plastic availability
  plastic_per_elephant * elephants + plastic_per_tiger * tigers <= plastic_available;

% Profit definition constraint
constraint
  % Total profit is the sum of per-unit profits times quantities produced
  total_profit = profit_elephant * elephants + profit_tiger * tigers;

% Objective
solve maximize total_profit;