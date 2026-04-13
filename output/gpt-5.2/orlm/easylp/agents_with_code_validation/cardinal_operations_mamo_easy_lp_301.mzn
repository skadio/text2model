% Parameters
% Unit costs for each project (embedded from problem statement)
int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Constraint right-hand sides (embedded from problem statement)
int: maxXY = 20;        % X + Y <= 20
int: min2YplusZ = 10;   % 2*Y + Z >= 10
int: maxXZ = 15;        % X + Z <= 15

% Upper bounds for decision variables (derived to keep variables bounded)
int: ubX = min(maxXY, maxXZ); % X <= 15
int: ubY = maxXY;             % Y <= 20
int: ubZ = maxXZ;             % Z <= 15

% Variables
var 0..ubX: x; % whole-number investment in project X
var 0..ubY: y; % whole-number investment in project Y
var 0..ubZ: z; % whole-number investment in project Z

% Constraints
% Budget/compatibility constraint: combined allocation to X and Y is limited
constraint x + y <= maxXY;

% Minimum effort requirement: twice Y plus Z must reach at least the target
constraint 2 * y + z >= min2YplusZ;

% Additional limitation: combined allocation to X and Z is limited
constraint x + z <= maxXZ;

% Objective
solve minimize costX * x + costY * y + costZ * z;