% Parameters
int: maxS = 400;
int: maxL = 800;

int: wageS = 100;
int: wageL = 80;

int: effS = 42;
int: effL = 36;

int: req1 = 8400;
int: req2 = 10800;
int: req3 = 18000;

int: setupCost1B = 500;

% Variables
var 0..maxS: S;  % total skilled hired
var 0..maxL: L;  % total laborers hired

% Method choice binaries (exactly one per task)
var bool: t1A;
var bool: t1B;

var bool: t2A;
var bool: t2B;

var bool: t3A;
var bool: t3B;

% Weekly workers assigned per task (integers)
var 0..maxS: S1;
var 0..maxS: S2;
var 0..maxS: S3;

var 0..maxL: L1;
var 0..maxL: L2;
var 0..maxL: L3;

% Total cost
var int: totalCost;

% Constraints
constraint t1A + t1B = 1;
constraint t2A + t2B = 1;
constraint t3A + t3B = 1;

% Task 1 requirements and method structure
constraint effS * S1 + effL * L1 >= req1;
constraint L1 = 2 * S1;                         % 1 skilled : 2 laborers when used
constraint S1 <= maxS * t1B;                    % if not using B, then S1=0
constraint L1 <= maxL * t1B;                    % if not using B, then L1=0
constraint effS * S1 >= req1 * t1B;             % ensure enough if B chosen (redundant but tightens)

% Task 2 requirements and method structure
constraint effS * S2 >= req2 * t2A;
constraint S2 <= maxS * t2A;
constraint L2 = 0;                              % no laborers used in either method chosen here
constraint effL * 0 >= 0;

% If method B for Task 2: laborers alone
var 0..maxL: L2B;
constraint effL * L2B >= req2 * t2B;
constraint L2B <= maxL * t2B;

% Task 3 requirements and method structure
% If method A: groups of five laborers
var 0..maxL: L3A;
constraint L3A mod 5 = 0;
constraint effL * L3A >= req3 * t3A;
constraint L3A <= maxL * t3A;

% If method B: 1 skilled + 3 laborers
constraint L3 = 3 * S3;
constraint effS * S3 + effL * L3 >= req3 * t3B;
constraint S3 <= maxS * t3B;
constraint L3 <= maxL * t3B;

% Minimum skilled assignment if Task 3 uses method B
constraint S3 >= 20 * t3B;

% Exclusion rule: if Task 1 uses B then Task 3 cannot use A
constraint t1B + t3A <= 1;

% Total hired must cover assignments
constraint S >= S1 + S2 + S3;
constraint L >= L1 + L2B + L3A + L3;

% Hiring policy: skilled cannot exceed 60% of laborers => S <= 0.6 L => 5S <= 3L
constraint 5 * S <= 3 * L;

% Cost definition
constraint totalCost =
    wageS * S + wageL * L
  + setupCost1B * bool2int(t1B);

% Objective
solve minimize totalCost;