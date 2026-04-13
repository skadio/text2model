% Parameters
int: vitD_orange = 10;          % Vitamin D units per orange juice box
int: vitC_orange = 8;           % Vitamin C units per orange juice box
int: vitD_apple  = 12;          % Vitamin D units per apple juice box
int: vitC_apple  = 6;           % Vitamin C units per apple juice box

int: min_orange_boxes = 3;      % Must drink at least this many orange boxes
int: apple_to_orange_ratio = 3; % Must drink at least this many times apple as orange
int: max_vitC = 300;            % Maximum allowed total vitamin C units


% Variables
% Upper bounds derived from max_vitC to keep the model finite:
% orange_boxes <= floor(max_vitC / vitC_orange)
% apple_boxes  <= floor(max_vitC / vitC_apple)
var 0..(max_vitC div vitC_orange): orange_boxes;  % Number of orange juice boxes to drink
var 0..(max_vitC div vitC_apple):  apple_boxes;   % Number of apple juice boxes to drink

var int: total_vitD;                                % Total vitamin D intake (to maximize)
var 0..max_vitC: total_vitC;                        % Total vitamin C intake (bounded by max_vitC)


% Constraints
% --- Non-negativity and minimum consumption requirements ---
constraint orange_boxes >= min_orange_boxes;

% --- Preference constraint: apple juice at least given ratio of orange juice ---
constraint apple_boxes >= apple_to_orange_ratio * orange_boxes;

% --- Define total vitamin intakes from decision variables ---
constraint total_vitD = vitD_orange * orange_boxes + vitD_apple * apple_boxes;
constraint total_vitC = vitC_orange * orange_boxes + vitC_apple * apple_boxes;

% --- Vitamin C overdose prevention ---
constraint total_vitC <= max_vitC;


% Objective
solve maximize total_vitD;