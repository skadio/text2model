% Parameters
int: raw_len = 10;                 % Length of each raw steel bar (meters)
int: req3 = 90;                    % Required number of 3m pieces
int: req4 = 60;                    % Required number of 4m pieces
int: len3 = 3;                     % Piece length 3m
int: len4 = 4;                     % Piece length 4m

% Feasible cutting patterns for a 10m bar in terms of (#3m, #4m)
% Enumerated all (a,b) such that 3a + 4b <= 10
int: P = 8;                        % Number of patterns
set of int: PAT = 1..P;

array[PAT] of int: pat3 = [0,1,2,3,0,1,2,0];  % number of 3m pieces in pattern p
array[PAT] of int: pat4 = [0,0,0,0,1,1,1,2];  % number of 4m pieces in pattern p

% Waste per raw bar (meters) for each pattern
array[PAT] of int: waste =
  [ raw_len - (len3 * pat3[p] + len4 * pat4[p]) | p in PAT ];

% Upper bound on number of raw bars used (safe bound)
int: maxBars = req3 + req4;

% Variables
array[PAT] of var 0..maxBars: x;          % x[p] = number of raw bars cut using pattern p
var 0..(raw_len * maxBars): total_waste;  % Total waste (meters)

% Constraints

% Demand satisfaction: produce at least the required number of 3m pieces
constraint
  sum(p in PAT)(pat3[p] * x[p]) >= req3;

% Demand satisfaction: produce at least the required number of 4m pieces
constraint
  sum(p in PAT)(pat4[p] * x[p]) >= req4;

% Total waste definition: total_waste equals the sum of waste from each used pattern
constraint
  total_waste = sum(p in PAT)(waste[p] * x[p]);

% Objective
solve minimize total_waste;