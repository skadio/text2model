% Fisherman's Fishing Optimization Problem

% Data parameters (provided in a .dzn file)
int: TotalAcres;         % Total available acres of the lake
int: TotalBait;          % Total available bait
int: MaxPain;            % Maximum tolerable pain for the fisherman
int: FishPerNetAcre;     % Fish caught per acre using a net
int: FishPerLineAcre;    % Fish caught per acre using a fishing line
int: BaitPerNetAcre;     % Bait required per acre using a net
int: BaitPerLineAcre;    % Bait required per acre using a fishing line
int: PainPerNetAcre;     % Pain caused per acre using a net
int: PainPerLineAcre;    % Pain caused per acre using a fishing line

% Decision variables: Acres to fish with Net and Line
var 0..TotalAcres: NetAcres;
var 0..TotalAcres: LineAcres;

% Constraints
constraint NetAcres + LineAcres <= TotalAcres;  % Total used acres cannot exceed available acres
constraint NetAcres * BaitPerNetAcre + LineAcres * BaitPerLineAcre <= TotalBait;    % Total bait used constraint
constraint NetAcres * PainPerNetAcre + LineAcres * PainPerLineAcre <= MaxPain;        % Pain limit constraint

% Objective: maximize total fish caught
var int: TotalFish = NetAcres * FishPerNetAcre + LineAcres * FishPerLineAcre;

solve maximize TotalFish;

% Output the chosen acres for each method and the total fish caught
output [
  "NetAcres = ", show(NetAcres), "\n",
  "LineAcres = ", show(LineAcres), "\n",
  "Total Fish Caught = ", show(TotalFish), "\n"
];