% Parameters
int: min_vitA = 80;                 % minimum required vitamin A
int: min_vitC = 100;                % minimum required vitamin C

int: vitA_crab = 5;                 % vitamin A per crab cake
int: vitC_crab = 7;                 % vitamin C per crab cake
int: vitA_lobster = 8;              % vitamin A per lobster roll
int: vitC_lobster = 4;              % vitamin C per lobster roll

int: fat_crab = 4;                  % unsaturated fat per crab cake
int: fat_lobster = 6;               % unsaturated fat per lobster roll

int: lobster_pct_num = 40;          % at most 40% lobster meals (numerator)
int: lobster_pct_den = 100;         % at most 40% lobster meals (denominator)

% Upper bounds (safe bounds derived from vitamin requirements)
int: ub_crab = max( (min_vitA + vitA_crab - 1) div vitA_crab,
                    (min_vitC + vitC_crab - 1) div vitC_crab );
int: ub_lobster = max( (min_vitA + vitA_lobster - 1) div vitA_lobster,
                       (min_vitC + vitC_lobster - 1) div vitC_lobster );

% Variables
var 0..ub_crab: n_crab;             % number of crab cakes
var 0..ub_lobster: n_lobster;       % number of lobster rolls
var 0..(fat_crab*ub_crab + fat_lobster*ub_lobster): total_fat;  % total unsat. fat

% Constraints

% --- Nutrition requirements: meet minimum vitamins ---
constraint
  vitA_crab * n_crab + vitA_lobster * n_lobster >= min_vitA;

constraint
  vitC_crab * n_crab + vitC_lobster * n_lobster >= min_vitC;

% --- Lobster proportion limit: lobster meals <= 40% of total meals ---
% Enforce: n_lobster / (n_crab + n_lobster) <= lobster_pct_num / lobster_pct_den
% Use cross-multiplication to stay in integers:
constraint
  lobster_pct_den * n_lobster <= lobster_pct_num * (n_crab + n_lobster);

% --- Total unsaturated fat definition ---
constraint
  total_fat = fat_crab * n_crab + fat_lobster * n_lobster;

% Objective
solve minimize total_fat;