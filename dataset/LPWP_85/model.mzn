% ============================================================
% FISHING OPTIMIZATION MODEL
% ============================================================
%
% PROBLEM DESCRIPTION:
% -------------------
% A fisherman wants to maximize the number of fish caught while considering
% the available resources. There are two fishing methods: using a net and using
% a fishing line.
%
% - Each method catches a different number of fish per acre.
% - Each method consumes a certain amount of bait.
% - Each method causes a different level of physical pain to the fisherman.
%
% OBJECTIVE:
% ----------
% Find the optimal number of acres to use each method while:
% - Staying within the total available bait.
% - Keeping pain levels within the tolerable limit.
% - Ensuring the total number of acres fished does not exceed the lake size.
%
% PARAMETERS PROVIDED IN JSON:
% {
%   "TotalAcres": <int>, "TotalBait": <int>, "MaxPain": <int>,
%   "FishPerNetAcre": <int>, "FishPerLineAcre": <int>,
%   "BaitPerNetAcre": <int>, "BaitPerLineAcre": <int>,
%   "PainPerNetAcre": <int>, "PainPerLineAcre": <int>
% }
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: TotalAcres;      % Total available acres of the lake
int: TotalBait;       % Total available bait
int: MaxPain;         % Maximum tolerable pain for the fisherman

int: FishPerNetAcre;  % Fish caught per acre using a net
int: FishPerLineAcre; % Fish caught per acre using a fishing line

int: BaitPerNetAcre;  % Bait required per acre using a net
int: BaitPerLineAcre; % Bait required per acre using a fishing line

int: PainPerNetAcre;  % Pain caused per acre using a net
int: PainPerLineAcre; % Pain caused per acre using a fishing line


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

% The number of acres allocated to each fishing method (bounded by total acres)
var 0..TotalAcres: NetAcres;
var 0..TotalAcres: LineAcres;

% The total number of fish caught
var int: TotalFish;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Total Acres Constraint: The sum of acres used must not exceed the lake size.
constraint
    NetAcres + LineAcres <= TotalAcres;

% (C2) Bait Constraint: The total bait consumption cannot exceed available bait.
constraint
    NetAcres * BaitPerNetAcre + LineAcres * BaitPerLineAcre <= TotalBait;

% (C3) Pain Constraint: The total pain experienced must not exceed the tolerable limit.
constraint
    NetAcres * PainPerNetAcre + LineAcres * PainPerLineAcre <= MaxPain;

% (C4) Total Fish Calculation:
% The total number of fish caught is the sum of fish from both methods.
constraint
    TotalFish = NetAcres * FishPerNetAcre + LineAcres * FishPerLineAcre;


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------

% Maximize the total number of fish caught.
solve maximize TotalFish;


% -----------------------------
% 5) OUTPUT
% -----------------------------

% Print the number of acres allocated to each method and the maximum fish caught.
output [
    "Optimal Fishing Strategy:\n",
    "  Acres Fished Using Net: ", show(NetAcres), "\n",
    "  Acres Fished Using Fishing Line: ", show(LineAcres), "\n",
    "Maximum Fish Caught: ", show(TotalFish), "\n"
];