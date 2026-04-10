% Parameters
int: profit_scooter = 200;               % Profit per scooter ($)
int: profit_bike = 300;                  % Profit per bike ($)

int: design_hours_per_scooter = 2;       % Design hours needed per scooter
int: engineering_hours_per_scooter = 3;  % Engineering hours needed per scooter

int: design_hours_per_bike = 4;          % Design hours needed per bike
int: engineering_hours_per_bike = 5;     % Engineering hours needed per bike

int: design_hours_available = 5000;      % Total available design hours per month
int: engineering_hours_available = 6000; % Total available engineering hours per month


% Variables
var 0..(design_hours_available div design_hours_per_scooter): scooters; % Number of scooters produced
var 0..(design_hours_available div design_hours_per_bike): bikes;       % Number of bikes produced

% Upper bound uses design capacity as a safe (though not necessarily tight) bound.
var 0..(profit_scooter * (design_hours_available div design_hours_per_scooter)
      + profit_bike * (design_hours_available div design_hours_per_bike)): total_profit; % Total profit


% Constraints
% Link total_profit to production quantities
constraint
  total_profit = profit_scooter * scooters + profit_bike * bikes;

% Design team capacity constraint
constraint
  design_hours_per_scooter * scooters + design_hours_per_bike * bikes
  <= design_hours_available;

% Engineering team capacity constraint
constraint
  engineering_hours_per_scooter * scooters + engineering_hours_per_bike * bikes
  <= engineering_hours_available;


% Objective
solve maximize total_profit;