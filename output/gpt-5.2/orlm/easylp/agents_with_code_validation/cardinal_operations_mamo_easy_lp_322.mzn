% Parameters
int: costX = 5;                     % cost per package to region X ($)
int: costY = 4;                     % cost per package to region Y ($)
int: costZ = 3;                     % cost per package to region Z ($)

int: maxXY = 20;                    % upper bound on X+Y
int: minYZ = 30;                    % lower bound on Y+Z
int: maxDiffXZ = 10;                % |X-Z| upper bound


% Variables
var 0..maxXY: packagesX;            % whole packages delivered to region X (nonnegative)
var 0..maxXY: packagesY;            % whole packages delivered to region Y (nonnegative)

% Z has no direct explicit upper bound; use a safe bound derived from constraints.
var 0..(minYZ + maxXY): packagesZ;  % whole packages delivered to region Z (nonnegative)

var int: totalCost;                 % total delivery cost ($)


% Constraints
% Total cost definition (link decision variables to totalCost)
constraint
  totalCost = costX * packagesX + costY * packagesY + costZ * packagesZ;

% Capacity/transport constraint: combined deliveries to X and Y cannot exceed maxXY
constraint
  packagesX + packagesY <= maxXY;

% Demand constraint: combined deliveries to Y and Z must be at least minYZ
constraint
  packagesY + packagesZ >= minYZ;

% Balance constraint: difference between deliveries to X and Z must not exceed maxDiffXZ
constraint
  abs(packagesX - packagesZ) <= maxDiffXZ;


% Objective
solve minimize totalCost;