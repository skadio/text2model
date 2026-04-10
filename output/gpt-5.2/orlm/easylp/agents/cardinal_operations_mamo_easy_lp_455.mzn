% Parameters
int: costX = 5000;                 % cost per unit of project X
int: costY = 7000;                 % cost per unit of project Y

int: minX = 0;                     % lower bound on X
int: maxX = 5;                     % upper bound on X
int: minY = 0;                     % lower bound on Y
int: maxY = 4;                     % upper bound on Y

int: maxTotalProjects = 8;         % manpower limit: X + Y <= 8
int: requiredStrength = 10;        % minimum required combined strength

int: strengthXcoef = 2;            % strength contribution coefficient for X
int: strengthYcoef = 3;            % strength contribution coefficient for Y

% Variables
var minX..maxX: x;                 % number of units allocated to project X (integer)
var minY..maxY: y;                 % number of units allocated to project Y (integer)

var 0..(maxX + maxY): totalProjects;                 % total number of projects (X + Y)
var 0..(costX*maxX + costY*maxY): totalCost;         % total cost to minimize (in dollars)

% Constraints
% Link aggregate variables to decision variables
constraint totalProjects = x + y;
constraint totalCost = costX * x + costY * y;

% Manpower limit: total projects cannot exceed availability
constraint totalProjects <= maxTotalProjects;

% Contract strength requirement: combined strength must meet or exceed threshold
constraint strengthXcoef * x + strengthYcoef * y >= requiredStrength;

% Balance requirement: project Y must have at least one more unit than project X
constraint y >= x + 1;

% Objective
solve minimize totalCost;