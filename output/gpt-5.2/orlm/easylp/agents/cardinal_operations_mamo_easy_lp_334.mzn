% Parameters
% Budget caps
int: capXY = 5000;              % Maximum combined investment in projects X and Y
int: capZW = 2000;              % Maximum combined investment in projects Z and W

% Cross-project minimum difference requirements
int: minDiffXZ = 1000;          % X must be at least this much more than Z
int: minDiffYW = 1500;          % Y must be at least this much more than W

% Individual project bounds
int: maxX = 4000;               % Upper bound on X
int: maxY = 3000;               % Upper bound on Y
int: minZ = 500;                % Lower bound on Z
int: minW = 200;                % Lower bound on W

% Per-unit costs (treated as costs to minimize)
int: costX = 20;                % $ per unit in X
int: costY = 30;                % $ per unit in Y
int: costZ = 50;                % $ per unit in Z
int: costW = 10;                % $ per unit in W


% Variables
var 0..maxX: x;                 % Investment in project X (integer units)
var 0..maxY: y;                 % Investment in project Y (integer units)
var minZ..capZW: z;             % Investment in project Z (integer units), bounded above by capZW
var minW..capZW: w;             % Investment in project W (integer units), bounded above by capZW

var int: totalCost;             % Total cost in dollars (integer)


% Constraints
%------------------------------------------------------------
% Budget cap constraints (combined investments)
%------------------------------------------------------------
constraint x + y <= capXY;      % Total investment in X and Y cannot exceed capXY
constraint z + w <= capZW;      % Total investment in Z and W cannot exceed capZW

%------------------------------------------------------------
% Cross-project minimum difference requirements
%------------------------------------------------------------
constraint x - z >= minDiffXZ;  % X must be at least minDiffXZ units more than Z
constraint y - w >= minDiffYW;  % Y must be at least minDiffYW units more than W

%------------------------------------------------------------
% Total cost definition (linear expression)
%------------------------------------------------------------
constraint totalCost = costX * x + costY * y + costZ * z + costW * w;


% Objective
solve minimize totalCost;