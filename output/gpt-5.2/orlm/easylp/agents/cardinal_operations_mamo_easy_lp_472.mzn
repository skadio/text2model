% Parameters
int: max_total_matches = 50;          % Upper limit on total matches: X + Y <= 50
int: min_competitiveness = 30;        % Lower limit on competitiveness: 2*X + Y >= 30
int: max_imbalance = 10;              % Upper limit on imbalance: X - 2*Y <= 10

int: fatigue_x = 4;                   % Fatigue per match of sport X
int: fatigue_y = 3;                   % Fatigue per match of sport Y

% Variables
var 0..max_total_matches: matches_x;  % Number of matches for sport X (integer, non-negative)
var 0..max_total_matches: matches_y;  % Number of matches for sport Y (integer, non-negative)

var 0..(fatigue_x * max_total_matches + fatigue_y * max_total_matches): total_fatigue;
                                      % Total fatigue score to minimize (bounded)

% Constraints
% Total match capacity constraint: cannot exceed scheduling limit
constraint matches_x + matches_y <= max_total_matches;

% Competitiveness constraint: ensure sufficient combined weighted match count
constraint 2 * matches_x + matches_y >= min_competitiveness;

% Balance/imbalance constraint: keep sport mix within allowed difference
constraint matches_x - 2 * matches_y <= max_imbalance;

% Define total fatigue based on per-match fatigue scores
constraint total_fatigue = fatigue_x * matches_x + fatigue_y * matches_y;

% Objective
solve minimize total_fatigue;

% (Optional) Output for inspection
output [
  "matches_x = ", show(matches_x), "\n",
  "matches_y = ", show(matches_y), "\n",
  "total_fatigue = ", show(total_fatigue), "\n"
];