int: TotalAcres;                % Total available acres of the lake
int: FishPerNetAcre;            % Fish caught per acre using a net
int: FishPerLineAcre;           % Fish caught per acre using a fishing line
int: BaitPerNetAcre;            % Bait required per acre using a net
int: BaitPerLineAcre;           % Bait required per acre using a fishing line
int: TotalBait;                 % Total available bait
int: PainPerNetAcre;            % Pain caused per acre using a net
int: PainPerLineAcre;           % Pain caused per acre using a fishing line
int: MaxPain;                   % Maximum tolerable pain for the fisherman

% Decision variables
var 0..TotalAcres: NetAcres;   % Acres of the lake where the net is used
var 0..TotalAcres: LineAcres;  % Acres of the lake where the fishing line is used

% Objective: Maximize total fish caught
var int: TotalFish = FishPerNetAcre * NetAcres + FishPerLineAcre * LineAcres;

% Constraints
constraint NetAcres + LineAcres <= TotalAcres;                     % Total area constraint
constraint BaitPerNetAcre * NetAcres + BaitPerLineAcre * LineAcres <= TotalBait; % Bait constraint
constraint PainPerNetAcre * NetAcres + PainPerLineAcre * LineAcres <= MaxPain;   % Pain constraint

% Solve & output
solve maximize TotalFish;
output [ "Net Acres = ", show(NetAcres), "\nLine Acres = ", show(LineAcres), "\nTotal Fish Caught = ", show(TotalFish), "\n" ];