% Science Fair Table Setup Model

% Parameters provided via the .dzn file
int: CircularTables;           % Maximum number of circular tables available
int: RectangularTables;        % Maximum number of rectangular tables available
int: ParticipantsPerCircular;  % Participants at each circular table
int: ParticipantsPerRectangular; % Participants at each rectangular table
int: BoardsPerCircular;        % Poster boards at each circular table
int: BoardsPerRectangular;     % Poster boards at each rectangular table
int: GuestsPerCircular;        % Guests catered by each circular table
int: GuestsPerRectangular;     % Guests catered by each rectangular table
int: SpacePerCircular;         % Space required for each circular table
int: SpacePerRectangular;      % Space required for each rectangular table
int: TotalSpace;               % Total available space
int: MinParticipants;          % Minimum required participants
int: MinBoards;                % Minimum required poster boards

% Decision variables: number of tables to set up
var 0..CircularTables: numCircular;
var 0..RectangularTables: numRectangular;

% Derived quantities
var int: totalSpaceUsed = numCircular * SpacePerCircular + numRectangular * SpacePerRectangular;
var int: totalParticipants = numCircular * ParticipantsPerCircular + numRectangular * ParticipantsPerRectangular;
var int: totalBoards = numCircular * BoardsPerCircular + numRectangular * BoardsPerRectangular;
var int: totalGuests = numCircular * GuestsPerCircular + numRectangular * GuestsPerRectangular;

% Constraints
constraint totalSpaceUsed <= TotalSpace;
constraint totalParticipants >= MinParticipants;
constraint totalBoards >= MinBoards;

% Objective: maximize number of guests catered
solve maximize totalGuests;

% Output the decision variables and derived values
output [
    "Number of Circular Tables: ", show(numCircular), "\n",
    "Number of Rectangular Tables: ", show(numRectangular), "\n",
    "Total Space Used: ", show(totalSpaceUsed), " / ", show(TotalSpace), "\n",
    "Total Participants: ", show(totalParticipants), " (minimum required: ", show(MinParticipants), ")\n",
    "Total Poster Boards: ", show(totalBoards), " (minimum required: ", show(MinBoards), ")\n",
    "Total Guests: ", show(totalGuests), "\n"
];