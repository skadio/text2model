% Parameters
int: totalResourceLimit = 1000;     % Maximum total resources available for both campaigns
int: minExtraX = 300;               % Additional units required for X beyond twice Y
int: costPerUnitX = 4;              % Cost per unit allocated to campaign X
int: costPerUnitY = 3;              % Cost per unit allocated to campaign Y

% Variables
var 0..totalResourceLimit: allocX;  % Integer units allocated to campaign X
var 0..totalResourceLimit: allocY;  % Integer units allocated to campaign Y
var 0..(costPerUnitX*totalResourceLimit + costPerUnitY*totalResourceLimit): totalCost; % Total cost

% Constraints
%--- Resource budget limit (total allocation cannot exceed available resources)
constraint
  allocX + allocY <= totalResourceLimit;

%--- Campaign relationship requirement (X must be at least twice Y plus an extra amount)
constraint
  allocX >= 2 * allocY + minExtraX;

%--- Total cost calculation (define totalCost from allocations and unit costs)
constraint
  totalCost = costPerUnitX * allocX + costPerUnitY * allocY;

% Objective
solve minimize totalCost;