% Parameters
int: salaryX = 5000;              % Monthly salary for position X
int: salaryY = 8000;              % Monthly salary for position Y
int: maxTotalHires = 100;         % Maximum total hires allowed
int: minHiresX = 20;              % Minimum hires required for position X
int: minHiresY = 30;              % Minimum hires required for position Y

% Variables
var minHiresX..maxTotalHires: hiresX;  % Number of employees hired for position X (integer)
var minHiresY..maxTotalHires: hiresY;  % Number of employees hired for position Y (integer)
var 0..(salaryX * maxTotalHires + salaryY * maxTotalHires): totalMonthlyCost; % Total monthly salary cost (dollars)

% Constraints
% Total hires must respect the overall hiring cap
constraint
  hiresX + hiresY <= maxTotalHires;

% Define total monthly cost from hires and salaries
constraint
  totalMonthlyCost = salaryX * hiresX + salaryY * hiresY;

% Objective
solve minimize totalMonthlyCost;