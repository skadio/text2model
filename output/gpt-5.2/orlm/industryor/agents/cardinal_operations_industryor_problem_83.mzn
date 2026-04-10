% Parameters
int: nCandidates = 5;                          % number of candidates
set of int: CANDIDATES = 1..nCandidates;       % candidate index set

set of int: DEGREE_LEVELS = 0..3;              % 0=None, 1=Bachelor, 2=Master, 3=Doctor

array[CANDIDATES] of int: salary = [8100, 20000, 21000, 3000, 8000];     % salary requirement
array[CANDIDATES] of int: degree = [1, 2, 3, 0, 0];                      % degree level per candidate
array[CANDIDATES] of int: experience = [3, 10, 4, 3, 7];                 % years of work experience

int: max_hires = 3;                              % maximum number of hires
int: min_hires = 2;                              % minimum number of hires
int: budget = 35000;                             % total salary budget
int: min_experience_total = 12;                  % minimum total experience

set of int: advanced_degree = {2, 3};            % Master or Doctor
set of int: AE_pair = {1, 5};                    % indices for candidates A and E


% Variables
array[CANDIDATES] of var 0..1: hire;             % 1 if candidate is hired, else 0

var 0..sum(salary): total_salary;                % total salary paid to hired candidates
var 0..nCandidates: total_hires;                 % number of hired candidates
var 0..sum(experience): total_experience;        % total years of experience of hired candidates
var 0..1: has_advanced_degree;                   % 1 if at least one hired has Master/Doctor


% Constraints
% Link aggregate variables to hire decisions
constraint total_salary = sum(c in CANDIDATES)(salary[c] * hire[c]);
constraint total_hires = sum(c in CANDIDATES)(hire[c]);
constraint total_experience = sum(c in CANDIDATES)(experience[c] * hire[c]);

% Hiring count bounds (at least 2 and at most 3)
constraint total_hires >= min_hires;
constraint total_hires <= max_hires;

% Budget constraint (total salary within budget)
constraint total_salary <= budget;

% Minimum total work experience requirement
constraint total_experience >= min_experience_total;

% At least one hire with an advanced degree (Master or Doctor)
constraint
  has_advanced_degree = bool2int(
    exists(c in CANDIDATES where degree[c] in advanced_degree)(hire[c] = 1)
  );
constraint has_advanced_degree = 1;

% At most one hired among candidates A and E (equivalent skills)
constraint sum(c in AE_pair)(hire[c]) <= 1;


% Objective
solve minimize total_salary;