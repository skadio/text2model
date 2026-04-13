% Parameters
int: costX = 100;                  % Cost per unit funding for project X (USD)
int: costY = 200;                  % Cost per unit funding for project Y (USD)

int: maxTotalFunds = 50;           % Maximum combined units of funding for X and Y
int: minEffectiveness = 10;        % Minimum threshold for (3*X - Y)

int: minX = 0;                     % Minimum units for project X
int: maxX = 30;                    % Maximum units for project X
int: minY = 0;                     % Minimum units for project Y
int: maxY = 20;                    % Maximum units for project Y

% Variables
var minX..maxX: fundX;             % Integer units of funding allocated to project X
var minY..maxY: fundY;             % Integer units of funding allocated to project Y

var 0..(costX*maxX + costY*maxY): totalCost;  % Total cost (USD), bounded

% Constraints
% Total cost definition
constraint totalCost = costX * fundX + costY * fundY;

% Budget constraint: total allocated funds cannot exceed the maximum
constraint fundX + fundY <= maxTotalFunds;

% Effectiveness constraint: ensure minimum combined effectiveness
constraint 3 * fundX - fundY >= minEffectiveness;

% Objective
solve minimize totalCost;