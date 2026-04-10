% Parameters
int: profit_scooter = 200;               % Profit per scooter
int: profit_bike = 300;                  % Profit per bike

int: design_hours_per_scooter = 2;       % Design team hours needed per scooter
int: engineering_hours_per_scooter = 3;  % Engineering team hours needed per scooter

int: design_hours_per_bike = 4;          % Design team hours needed per bike
int: engineering_hours_per_bike = 5;     % Engineering team hours needed per bike

int: design_hours_available = 5000;      % Monthly design team hours available
int: engineering_hours_available = 6000; % Monthly engineering team hours available


% Variables
var 0..(design_hours_available div design_hours_per_scooter): scooters; % # scooters produced per month
var 0..(design_hours_available div design_hours_per_bike): bikes;       % # bikes produced per month


% Constraints
% Design team capacity constraint (total design hours used cannot exceed available)
constraint
  design_hours_per_scooter * scooters
+ design_hours_per_bike * bikes
<= design_hours_available;

% Engineering team capacity constraint (total engineering hours used cannot exceed available)
constraint
  engineering_hours_per_scooter * scooters
+ engineering_hours_per_bike * bikes
<= engineering_hours_available;


% Objective
solve maximize profit_scooter * scooters + profit_bike * bikes;