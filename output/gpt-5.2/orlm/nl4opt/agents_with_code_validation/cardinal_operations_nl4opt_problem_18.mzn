% Parameters
int: wood_per_elephant = 50;        % grams of wood required per elephant
int: plastic_per_elephant = 20;     % grams of plastic required per elephant
int: wood_per_tiger = 40;           % grams of wood required per tiger
int: plastic_per_tiger = 30;        % grams of plastic required per tiger

int: wood_available = 5000;         % total grams of wood available per week
int: plastic_available = 4000;      % total grams of plastic available per week

int: profit_per_elephant = 5;       % dollars profit per elephant
int: profit_per_tiger = 4;          % dollars profit per tiger

% Upper bounds derived from resource limits (for bounded decision variables)
int: max_elephants = min(wood_available div wood_per_elephant,
                         plastic_available div plastic_per_elephant);
int: max_tigers = min(wood_available div wood_per_tiger,
                      plastic_available div plastic_per_tiger);

% Variables
var 0..max_elephants: elephants;    % number of elephants to make
var 0..max_tigers: tigers;          % number of tigers to make

var 0..(profit_per_elephant*max_elephants + profit_per_tiger*max_tigers): total_profit;

% Constraints

% Resource constraints: do not exceed weekly available materials
constraint
  wood_per_elephant * elephants + wood_per_tiger * tigers <= wood_available;

constraint
  plastic_per_elephant * elephants + plastic_per_tiger * tigers <= plastic_available;

% Accounting constraint: define total profit from quantities produced
constraint
  total_profit = profit_per_elephant * elephants + profit_per_tiger * tigers;

% Objective
solve maximize total_profit;