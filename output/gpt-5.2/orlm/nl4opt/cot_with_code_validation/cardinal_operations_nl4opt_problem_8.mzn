% Parameters
int: profit_scooter = 200;
int: profit_bike = 300;

int: design_per_scooter = 2;
int: engineering_per_scooter = 3;

int: design_per_bike = 4;
int: engineering_per_bike = 5;

int: design_hours_available = 5000;
int: engineering_hours_available = 6000;

% Variables
var 0..(design_hours_available div design_per_scooter): scooters;
var 0..(design_hours_available div design_per_bike): bikes;

% Constraints
constraint design_per_scooter * scooters + design_per_bike * bikes <= design_hours_available;
constraint engineering_per_scooter * scooters + engineering_per_bike * bikes <= engineering_hours_available;

% Objective
var 0..(profit_scooter * (design_hours_available div design_per_scooter)
      + profit_bike * (design_hours_available div design_per_bike)): total_profit;

constraint total_profit = profit_scooter * scooters + profit_bike * bikes;

solve maximize total_profit;