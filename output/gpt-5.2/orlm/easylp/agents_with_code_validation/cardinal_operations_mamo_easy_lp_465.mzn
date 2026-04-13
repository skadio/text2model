% Parameters
int: minHoursX = 10;          % Minimum hours for Team X
int: minHoursY = 5;           % Minimum hours for Team Y
int: maxTotalHours = 40;      % Maximum combined hours (budget constraint)

int: costPerHourX = 50;       % Cost per hour for Team X ($/hour)
int: costPerHourY = 80;       % Cost per hour for Team Y ($/hour)

% Variables
var minHoursX..maxTotalHours: hoursX;                 % Whole hours allocated to Team X
var minHoursY..maxTotalHours: hoursY;                 % Whole hours allocated to Team Y
var 0..(costPerHourX*maxTotalHours + costPerHourY*maxTotalHours): totalCost; % Total cost ($)

% Constraints
% Minimum hours requirements (team-level lower bounds)
constraint hoursX >= minHoursX;
constraint hoursY >= minHoursY;

% Budget/feasibility constraint: total allocated hours cannot exceed maximum
constraint hoursX + hoursY <= maxTotalHours;

% Define total cost as the linear combination of allocated hours and hourly rates
constraint totalCost = costPerHourX * hoursX + costPerHourY * hoursY;

% Objective
solve minimize totalCost;