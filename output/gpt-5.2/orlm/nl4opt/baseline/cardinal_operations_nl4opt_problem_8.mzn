% Custom scooters and bikes production optimization (embedded data)

int: profit_scooter = 200;
int: profit_bike    = 300;

int: design_per_scooter = 2;
int: eng_per_scooter    = 3;

int: design_per_bike = 4;
int: eng_per_bike    = 5;

int: design_hours_available = 5000;
int: eng_hours_available    = 6000;

% Decision variables: number produced per month
var 0..design_hours_available div design_per_scooter: scooters;
var 0..design_hours_available div design_per_bike: bikes;

% Resource constraints
constraint design_per_scooter * scooters + design_per_bike * bikes <= design_hours_available;
constraint eng_per_scooter    * scooters + eng_per_bike    * bikes <= eng_hours_available;

% Objective: maximize profit
var int: total_profit = profit_scooter * scooters + profit_bike * bikes;
solve maximize total_profit;

output [
  "scooters=", show(scooters), "\n",
  "bikes=", show(bikes), "\n",
  "profit=", show(total_profit), "\n"
];