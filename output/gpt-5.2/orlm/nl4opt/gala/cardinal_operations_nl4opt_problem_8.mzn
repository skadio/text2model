% Scooter/Bike production planning (maximize monthly profit)

% Data (embedded from description)
int: profit_scooter = 200;
int: profit_bike    = 300;

int: design_scooter = 2;
int: eng_scooter    = 3;

int: design_bike = 4;
int: eng_bike    = 5;

int: design_cap = 5000;
int: eng_cap    = 6000;

% Decision variables: how many to make (nonnegative integers)
var 0..min(design_cap div design_scooter, eng_cap div eng_scooter): scooters;
var 0..min(design_cap div design_bike,    eng_cap div eng_bike):    bikes;

% Capacity constraints
constraint design_scooter * scooters + design_bike * bikes <= design_cap;
constraint eng_scooter * scooters + eng_bike * bikes <= eng_cap;

% Objective: maximize profit
var int: total_profit = profit_scooter * scooters + profit_bike * bikes;

solve maximize total_profit;

output [
  "scooters = ", show(scooters), "\n",
  "bikes    = ", show(bikes), "\n",
  "profit   = $", show(total_profit), "\n",
  "design_used = ", show(design_scooter * scooters + design_bike * bikes),
  " / ", show(design_cap), "\n",
  "eng_used    = ", show(eng_scooter * scooters + eng_bike * bikes),
  " / ", show(eng_cap), "\n"
];