% Parameters
int: raw_length = 10;              % Length of each raw steel bar (meters)

int: demand_3m = 90;               % Required number of 3-meter pieces
int: demand_4m = 60;               % Required number of 4-meter pieces

% Maximum feasible counts of each piece length per raw bar
int: max_3m_per_bar = raw_length div 3;   % floor(10/3) = 3
int: max_4m_per_bar = raw_length div 4;   % floor(10/4) = 2

% Enumerate all feasible cutting patterns (a,b) with:
% a = number of 3m pieces, b = number of 4m pieces, and 3a + 4b <= 10
set of int: A = 0..max_3m_per_bar;
set of int: B = 0..max_4m_per_bar;

% Build the set of feasible (a,b) pairs once, then index patterns by 1..N
set of (int,int): FEAS = { (a,b) | a in A, b in B where 3*a + 4*b <= raw_length };
int: nPatterns = card(FEAS);
set of int: PATTERNS = 1..nPatterns;

array[PATTERNS] of int: pat_3m =
  [ a | (a,b) in FEAS ];

array[PATTERNS] of int: pat_4m =
  [ b | (a,b) in FEAS ];

array[PATTERNS] of int: pat_waste =
  [ raw_length - (3*a + 4*b) | (a,b) in FEAS ];

% Variables
array[PATTERNS] of var 0..(demand_3m + demand_4m): use_pattern;  % Bars cut with each pattern
var 0..(raw_length * (demand_3m + demand_4m)): total_waste;      % Total waste (meters)
var 0..(demand_3m + demand_4m): total_bars;                      % Total raw bars used

% Constraints

% --- Demand satisfaction (produce at least the required number of pieces) ---
constraint
  sum(p in PATTERNS)(pat_3m[p] * use_pattern[p]) >= demand_3m;
constraint
  sum(p in PATTERNS)(pat_4m[p] * use_pattern[p]) >= demand_4m;

% --- Link total number of raw bars to pattern usage ---
constraint
  total_bars = sum(p in PATTERNS)(use_pattern[p]);

% --- Compute total waste from selected cutting patterns ---
constraint
  total_waste = sum(p in PATTERNS)(pat_waste[p] * use_pattern[p]);

% Objective
solve minimize total_waste;