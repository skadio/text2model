% Taxi fleet optimization: motorcycles vs sedans

int: capacity_motorcycle = 30;
int: pollution_motorcycle = 4;
int: profit_motorcycle = 100;

int: capacity_sedan = 70;
int: pollution_sedan = 15;
int: profit_sedan = 225;

int: min_people = 1200;
int: pollution_limit = 199; % "less than 200"

% Decision variables
var 0..1000: motorcycles;
var 0..1000: sedans;

% Constraints
constraint capacity_motorcycle * motorcycles + capacity_sedan * sedans >= min_people;
constraint pollution_motorcycle * motorcycles + pollution_sedan * sedans <= pollution_limit;

% At most 25% motorcycles: motorcycles <= 0.25*(motorcycles+sedans)
% Equivalent linear form: 3*motorcycles <= sedans
constraint 3 * motorcycles <= sedans;

% Objective: maximize earnings per shift
var int: total_earnings = profit_motorcycle * motorcycles + profit_sedan * sedans;
solve maximize total_earnings;

output [
  "motorcycles=", show(motorcycles), "\n",
  "sedans=", show(sedans), "\n",
  "total_people=", show(capacity_motorcycle * motorcycles + capacity_sedan * sedans), "\n",
  "total_pollution=", show(pollution_motorcycle * motorcycles + pollution_sedan * sedans), "\n",
  "total_earnings=", show(total_earnings), "\n"
];