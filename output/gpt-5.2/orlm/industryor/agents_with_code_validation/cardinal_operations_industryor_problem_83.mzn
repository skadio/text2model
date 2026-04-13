% Parameters
int: nCandidates = 5;                         % number of candidates
set of int: CANDIDATES = 1..nCandidates;      % candidate index set

% Candidate order: 1=A, 2=B, 3=C, 4=D, 5=E
array[CANDIDATES] of int: salary = [8100, 20000, 21000, 3000, 8000];     % salary requirement per candidate
array[CANDIDATES] of int: experience = [3, 10, 4, 3, 7];                 % years of work experience per candidate

array[CANDIDATES] of bool: has_grad_degree = [false, true, true, false, false]; % Masters or Doctoral degree

int: max_hires = 3;                % maximum number of hires
int: min_hires = 2;                % minimum number of hires
int: budget = 35000;               % total salary budget
int: min_total_experience = 12;    % minimum total experience required

int: candA = 1;                    % index for candidate A
int: candE = 5;                    % index for candidate E


% Variables
array[CANDIDATES] of var 0..1: hire;          % hire[i]=1 if candidate i is hired, else 0
var 0..budget: total_salary;                  % total salary of hired candidates
var 0..sum(experience): total_experience;     % total experience of hired candidates
var min_hires..max_hires: num_hires;          % number of hired candidates (bounded by min/max)


% Constraints

%-----------------------------
% Link aggregate variables
%-----------------------------
constraint
  total_salary = sum(i in CANDIDATES)(salary[i] * hire[i]);

constraint
  total_experience = sum(i in CANDIDATES)(experience[i] * hire[i]);

constraint
  num_hires = sum(i in CANDIDATES)(hire[i]);

%-----------------------------
% Hiring count bounds
%-----------------------------
constraint
  min_hires <= num_hires /\ num_hires <= max_hires;

%-----------------------------
% Budget feasibility
%-----------------------------
constraint
  total_salary <= budget;

%-----------------------------
% Qualification requirement
%-----------------------------
constraint
  sum(i in CANDIDATES where has_grad_degree[i]) (hire[i]) >= 1;

%-----------------------------
% Experience requirement
%-----------------------------
constraint
  total_experience >= min_total_experience;

%-----------------------------
% Mutual exclusivity (A vs E)
%-----------------------------
constraint
  hire[candA] + hire[candE] <= 1;


% Objective
solve minimize total_salary;