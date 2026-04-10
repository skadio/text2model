% Parameters
int: nCandidates = 5;                         % number of candidates
set of int: CANDIDATES = 1..nCandidates;      % index set for candidates

array[CANDIDATES] of string: candName = ["F","G","H","I","J"];  % candidate labels

array[CANDIDATES] of int: salary = [12000, 15000, 18000, 5000, 10000]; % salary requirement
int: budget = 40000;                          % total budget
int: maxHires = 4;                            % maximum number of hires allowed

array[CANDIDATES] of int: skill = [2, 3, 4, 1, 2];              % skill levels
int: minTotalSkill = 8;                        % minimum required total skill

array[CANDIDATES] of int: experience = [1, 2, 2, 5, 4];         % project mgmt experience years
int: minTotalExperience = 8;                   % minimum required total experience

int: idxG = 2;                                 % index of candidate G
int: idxJ = 5;                                 % index of candidate J

% Variables
array[CANDIDATES] of var 0..1: hire;           % hire[c]=1 if candidate c is hired, else 0
var 0..budget: totalSalary;                    % total salary paid (bounded by budget)
var 0..maxHires: numHires;                     % number of hired employees
var 0..sum(skill): totalSkill;                 % total skill level of hired employees
var 0..sum(experience): totalExperience;       % total project mgmt experience years

% Constraints

% --- Aggregate definitions (link decision variables to totals) ---
constraint totalSalary = sum(c in CANDIDATES)(salary[c] * hire[c]);
constraint numHires = sum(c in CANDIDATES)(hire[c]);
constraint totalSkill = sum(c in CANDIDATES)(skill[c] * hire[c]);
constraint totalExperience = sum(c in CANDIDATES)(experience[c] * hire[c]);

% --- Budget and hiring limit constraints ---
constraint totalSalary <= budget;          % do not exceed total salary budget
constraint numHires <= maxHires;           % hire at most the allowed number of candidates

% --- Minimum team capability constraints ---
constraint totalSkill >= minTotalSkill;            % ensure enough total skill level
constraint totalExperience >= minTotalExperience;  % ensure enough total project mgmt experience

% --- Mutual exclusivity constraint (G and J similar background) ---
constraint hire[idxG] + hire[idxJ] <= 1;   % choose at most one of candidates G and J

% Objective
solve minimize totalSalary;