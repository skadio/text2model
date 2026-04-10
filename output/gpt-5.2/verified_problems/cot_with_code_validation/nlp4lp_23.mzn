% Manpower planning with recruitment, redundancies, overmanning and short-time working
% Objective: minimize total redundancy cost (proxy for minimizing redundancies)

%--------------------------
% Parameters (from .dzn)
%--------------------------
int: K;                    % number of worker categories
int: I;                    % number of years

array[1..K, 1..I] of int: Requirement;

array[1..K] of int: Strength;           % initial workforce (all > 1 year service)
array[1..K] of float: LessOneWaste;     % wastage for new hires (< 1 year)
array[1..K] of float: MoreOneWaste;     % wastage for existing staff (>= 1 year)

array[1..K] of int: Recruit;            % max recruits per year and category
array[1..K] of int: CostRedundancy;

int: NumOverman;                        % company-wide max overmanning (heads)
array[1..K] of int: CostOverman;

int: NumShortwork;                      % max short-time per category per year
array[1..K] of int: CostShort;

%--------------------------
% Variables
%--------------------------
% End-of-year full-time headcount in category k at end of year t
array[1..K, 1..I] of var 0..sum(Strength): FT;

% Hires during year t in category k
array[1..K, 1..I] of var 0..max(Recruit): H;

% Redundancies during year t in category k
array[1..K, 1..I] of var 0..sum(Strength): R;

% Short-time workers during year t in category k (counted as half productivity)
array[1..K, 1..I] of var 0..NumShortwork: S;

% Overmanning (extra employees above requirement) during year t in category k
array[1..K, 1..I] of var 0..NumOverman: O;

%--------------------------
% Limits
%--------------------------
constraint forall(k in 1..K, t in 1..I) (H[k,t] <= Recruit[k]);
constraint forall(k in 1..K, t in 1..I) (S[k,t] <= NumShortwork);
constraint forall(t in 1..I) (sum(k in 1..K)(O[k,t]) <= NumOverman);

%--------------------------
% Workforce flow with wastage
% (Use integerized flow to avoid float var products)
%--------------------------
int: SCALE = 1000;

array[1..K] of int: keep_old =
  [ round((1.0 - MoreOneWaste[k]) * SCALE) | k in 1..K ];
array[1..K] of int: keep_new =
  [ round((1.0 - LessOneWaste[k]) * SCALE) | k in 1..K ];

constraint
  forall(k in 1..K) (
    FT[k,1] * SCALE =
        keep_old[k] * Strength[k]
      + keep_new[k] * H[k,1]
      - SCALE * R[k,1]
  );

constraint
  forall(k in 1..K, t in 2..I) (
    FT[k,t] * SCALE =
        keep_old[k] * FT[k,t-1]
      + keep_new[k] * H[k,t]
      - SCALE * R[k,t]
  );

%--------------------------
% Meet requirements
% Short-time counts as half: FT + 0.5*S must cover (Requirement + O)
% Multiply by 2 to keep integers: 2*FT + S >= 2*(Requirement + O)
%--------------------------
constraint
  forall(k in 1..K, t in 1..I) (
    2 * FT[k,t] + S[k,t] >= 2 * (Requirement[k,t] + O[k,t])
  );

%--------------------------
% Objective: minimize redundancies (via redundancy costs)
%--------------------------
solve minimize sum(k in 1..K, t in 1..I)(CostRedundancy[k] * R[k,t]);

% Optional output
output [
  "FT=\n", show(FT), "\n",
  "H=\n", show(H), "\n",
  "R=\n", show(R), "\n",
  "S=\n", show(S), "\n",
  "O=\n", show(O), "\n"
];