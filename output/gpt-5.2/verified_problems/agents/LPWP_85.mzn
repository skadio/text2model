% Parameters
int: NetAcres;            % (Input name provided; not used as a decision variable in this optimization model)
int: LineAcres;           % (Input name provided; not used as a decision variable in this optimization model)

int: TotalAcres;          % Total available acres of the lake

int: FishPerNetAcre;      % Fish caught per acre using a net
int: FishPerLineAcre;     % Fish caught per acre using a fishing line

int: BaitPerNetAcre;      % Bait required per acre using a net
int: BaitPerLineAcre;     % Bait required per acre using a fishing line
int: TotalBait;           % Total available bait

int: PainPerNetAcre;      % Pain caused per acre using a net
int: PainPerLineAcre;     % Pain caused per acre using a fishing line
int: MaxPain;             % Maximum tolerable pain for the fisherman


% Variables
var 0..TotalAcres: acresNet;    % Decision variable: acres fished using a net
var 0..TotalAcres: acresLine;   % Decision variable: acres fished using a fishing line

var 0..(FishPerNetAcre * TotalAcres + FishPerLineAcre * TotalAcres): totalFish; % Total fish caught
var 0..(BaitPerNetAcre * TotalAcres + BaitPerLineAcre * TotalAcres): totalBaitUsed; % Total bait used
var 0..(PainPerNetAcre * TotalAcres + PainPerLineAcre * TotalAcres): totalPain; % Total pain incurred


% Constraints
% --- Lake area allocation constraints ---
% Total acres used by both methods cannot exceed the available lake area.
constraint acresNet + acresLine <= TotalAcres;

% --- Resource (bait) constraint ---
% Total bait consumed by both fishing methods must not exceed available bait.
constraint totalBaitUsed = BaitPerNetAcre * acresNet + BaitPerLineAcre * acresLine;
constraint totalBaitUsed <= TotalBait;

% --- Pain tolerance constraint ---
% Total pain incurred by both fishing methods must not exceed maximum tolerable pain.
constraint totalPain = PainPerNetAcre * acresNet + PainPerLineAcre * acresLine;
constraint totalPain <= MaxPain;

% --- Fish accounting constraint ---
% Compute total fish caught from acres assigned to each method.
constraint totalFish = FishPerNetAcre * acresNet + FishPerLineAcre * acresLine;


% Objective
solve maximize totalFish;