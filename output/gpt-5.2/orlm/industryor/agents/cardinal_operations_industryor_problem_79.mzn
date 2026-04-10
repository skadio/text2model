% Parameters
int: max_skilled = 400;                 % maximum number of skilled workers available
int: max_labor   = 800;                 % maximum number of laborers available

int: wage_skilled = 100;                % weekly wage per skilled worker (yuan)
int: wage_labor   = 80;                 % weekly wage per laborer (yuan)

int: hours_skilled = 42;                % effective hours per week per skilled worker
int: hours_labor   = 36;                % effective hours per week per laborer

int: req1 = 8400;                       % effective hours required for Task 1
int: req2 = 10800;                      % effective hours required for Task 2
int: req3 = 18000;                      % effective hours required for Task 3

int: setup_cost_t1_methodB = 500;       % fixed weekly setup cost if Task 1 uses Method B

int: min_skilled_if_t3B = 20;           % minimum skilled assigned to Task 3 if Method B chosen


% Variables
% Method-selection binaries (exactly one method per task)
var 0..1: t1A;                          % 1 if Task 1 uses Method A (skilled-only)
var 0..1: t1B;                          % 1 if Task 1 uses Method B (1 skilled + 2 laborers teams)

var 0..1: t2A;                          % 1 if Task 2 uses Method A (skilled-only)
var 0..1: t2B;                          % 1 if Task 2 uses Method B (labor-only)

var 0..1: t3A;                          % 1 if Task 3 uses Method A (5 laborers teams)
var 0..1: t3B;                          % 1 if Task 3 uses Method B (1 skilled + 3 laborers teams)

% Numbers of workers assigned to each task (bounded by overall maxima)
var 0..max_skilled: s1;                 % skilled assigned to Task 1
var 0..max_labor:   l1;                 % laborers assigned to Task 1

var 0..max_skilled: s2;                 % skilled assigned to Task 2
var 0..max_labor:   l2;                 % laborers assigned to Task 2

var 0..max_skilled: s3;                 % skilled assigned to Task 3
var 0..max_labor:   l3;                 % laborers assigned to Task 3

% Totals hired (decision variables)
var 0..max_skilled: skilled_hired;      % total skilled workers hired
var 0..max_labor:   labor_hired;        % total laborers hired

% Total weekly cost (wages + fixed costs)
var 0..(wage_skilled*max_skilled + wage_labor*max_labor + setup_cost_t1_methodB): total_cost;


% Constraints
%--- Method selection: exactly one method per task ---
constraint t1A + t1B = 1;
constraint t2A + t2B = 1;
constraint t3A + t3B = 1;

%--- Link method choice to allowed worker types / ratios ---
% Task 1: A = skilled-only, B = (1 skilled + 2 laborers) teams
% If A chosen -> no laborers. If B chosen -> ratio l1 = 2*s1.
constraint (t1A = 1) -> (l1 = 0);
constraint (t1B = 1) -> (l1 = 2 * s1);

% Task 2: A = skilled-only, B = labor-only
constraint (t2A = 1) -> (l2 = 0);
constraint (t2B = 1) -> (s2 = 0);

% Task 3: A = labor-only in groups of 5, B = (1 skilled + 3 laborers) teams
constraint (t3A = 1) -> (s3 = 0);
constraint (t3A = 1) -> (l3 mod 5 = 0);
constraint (t3B = 1) -> (l3 = 3 * s3);

%--- Task hour requirements (must meet required effective hours) ---
constraint hours_skilled * s1 + hours_labor * l1 >= req1;
constraint hours_skilled * s2 + hours_labor * l2 >= req2;
constraint hours_skilled * s3 + hours_labor * l3 >= req3;

%--- Totals hired are totals assigned (all hired workers are allocated to tasks) ---
constraint skilled_hired = s1 + s2 + s3;
constraint labor_hired   = l1 + l2 + l3;

%--- Overall availability limits (redundant but explicit) ---
constraint skilled_hired <= max_skilled;
constraint labor_hired   <= max_labor;

%--- Exclusion rule: if Task 1 uses method B then Task 3 cannot use method A ---
constraint t1B + t3A <= 1;

%--- Minimum assignment rule: if Task 3 uses method B then at least min skilled assigned ---
constraint (t3B = 1) -> (s3 >= min_skilled_if_t3B);

%--- Hiring policy: skilled hired cannot exceed 60% of labor hired ---
% 10*skilled_hired <= 6*labor_hired  is equivalent to skilled_hired <= 0.6*labor_hired
constraint 10 * skilled_hired <= 6 * labor_hired;

%--- Total cost definition (wages + fixed setup cost if Task 1 uses method B) ---
constraint
  total_cost =
      wage_skilled * skilled_hired
    + wage_labor   * labor_hired
    + setup_cost_t1_methodB * t1B;


% Objective
solve minimize total_cost;