% Parameters
int: vitA_req = 80;                 % Minimum required vitamin A
int: vitC_req = 100;                % Minimum required vitamin C

int: vitA_crab = 5;                 % Vitamin A per crab cake
int: vitC_crab = 7;                 % Vitamin C per crab cake
int: fat_crab  = 4;                 % Unsaturated fat per crab cake

int: vitA_lob  = 8;                 % Vitamin A per lobster roll
int: vitC_lob  = 4;                 % Vitamin C per lobster roll
int: fat_lob   = 6;                 % Unsaturated fat per lobster roll

float: lobster_max_frac = 0.40;     % Maximum fraction of meals that can be lobster

% Variables
var 0..1000: crab_cakes;            % Number of crab cakes to eat
var 0..1000: lobster_rolls;         % Number of lobster rolls to eat

var 0..10000: total_fat;            % Total unsaturated fat intake (to minimize)

% Constraints

% --- Nutrient requirements (meet minimum vitamin intake) ---
constraint
  vitA_crab * crab_cakes + vitA_lob * lobster_rolls >= vitA_req;  % Vitamin A

constraint
  vitC_crab * crab_cakes + vitC_lob * lobster_rolls >= vitC_req;  % Vitamin C

% --- Lobster fraction restriction (at most lobster_max_frac of all meals) ---
% Original: lobster_rolls / (crab_cakes + lobster_rolls) <= lobster_max_frac
% Linearize without float*var by scaling:
% lobster_rolls <= 0.40*(crab_cakes + lobster_rolls)
% 10*lobster_rolls <= 4*(crab_cakes + lobster_rolls)  (multiply by 10)
% 6*lobster_rolls <= 4*crab_cakes                      (rearrange)
constraint
  6 * lobster_rolls <= 4 * crab_cakes;

% --- Define total fat (objective variable is linked here) ---
constraint
  total_fat = fat_crab * crab_cakes + fat_lob * lobster_rolls;

% Objective
solve minimize total_fat;

% Optional output
output [
  "crab_cakes=", show(crab_cakes), "\n",
  "lobster_rolls=", show(lobster_rolls), "\n",
  "total_fat=", show(total_fat), "\n"
];