% Parameters
% Effort score per hour for each activity (given directly in the description)
int: effortX = 5;  % Academic lessons (X)
int: effortY = 4;  % Extracurricular activities (Y)
int: effortZ = 3;  % Student counseling sessions (Z)

% Constraint constants (given directly in the description)
int: maxXY = 100;        % X + Y <= 100
int: minXZ = 50;         % X + Z >= 50
int: maxDiffYZ = 20;     % |Y - Z| <= 20

% Variables
% Decision variables: whole-number hours allocated to each activity
var 0..maxXY: X;                 % Hours for academic lessons
var 0..maxXY: Y;                 % Hours for extracurricular activities
var 0..(maxXY + maxDiffYZ): Z;   % Hours for counseling (safe explicit upper bound)

% Objective variable: total effort score
var 0..(effortX*maxXY + effortY*maxXY + effortZ*(maxXY + maxDiffYZ)): totalEffort;

% Constraints
% Define total effort score from activity hours and per-hour effort rates
constraint totalEffort = effortX * X + effortY * Y + effortZ * Z;

% Scheduling limitation: combined hours of X and Y cannot exceed maxXY
constraint X + Y <= maxXY;

% Balanced program requirement: combined hours of X and Z must be at least minXZ
constraint X + Z >= minXZ;

% Balance between extracurricular (Y) and counseling (Z): absolute difference bounded
constraint abs(Y - Z) <= maxDiffYZ;

% Objective
solve minimize totalEffort;