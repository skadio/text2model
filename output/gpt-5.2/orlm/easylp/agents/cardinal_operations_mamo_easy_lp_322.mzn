% Parameters
% Delivery cost per package to each region (in dollars)
int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Transportation / demand / balance constraints
int: maxXY = 20;        % X + Y <= 20
int: minYZ = 30;        % Y + Z >= 30
int: maxDiffXZ = 10;    % |X - Z| <= 10

% Variable bounds (nonnegative package counts; upper bounds derived from constraints)
% From X + Y <= 20 => X <= 20, Y <= 20
% From |X - Z| <= 10 and X <= 20 => Z <= X + 10 <= 30
int: maxX = maxXY;
int: maxY = maxXY;
int: maxZ = maxX + maxDiffXZ;

% Variables
var 0..maxX: packagesX; % number of packages delivered to region X
var 0..maxY: packagesY; % number of packages delivered to region Y
var 0..maxZ: packagesZ; % number of packages delivered to region Z

% Total cost (in dollars)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;

% Constraints
% Total delivery cost definition
constraint totalCost
  = costX * packagesX + costY * packagesY + costZ * packagesZ;

% Transportation capacity constraint: combined deliveries to X and Y cannot exceed maxXY
constraint packagesX + packagesY <= maxXY;

% Demand satisfaction constraint: combined deliveries to Y and Z must be at least minYZ
constraint packagesY + packagesZ >= minYZ;

% Service balance constraint: difference between deliveries to X and Z must not exceed maxDiffXZ
constraint abs(packagesX - packagesZ) <= maxDiffXZ;

% Objective
solve minimize totalCost;