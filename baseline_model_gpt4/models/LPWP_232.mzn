% Parameters
int: ParticipantsPerCircular;
int: ParticipantsPerRectangular;
int: BoardsPerCircular;
int: BoardsPerRectangular;
int: GuestsPerCircular;
int: GuestsPerRectangular;
int: SpacePerCircular;
int: SpacePerRectangular;
int: TotalSpace;
int: MinParticipants;
int: MinBoards;

% Decision Variables
var 0..TotalSpace div SpacePerCircular: CircularTables;
var 0..TotalSpace div SpacePerRectangular: RectangularTables;

% Constraints
constraint CircularTables * SpacePerCircular + RectangularTables * SpacePerRectangular <= TotalSpace;
constraint CircularTables * ParticipantsPerCircular + RectangularTables * ParticipantsPerRectangular >= MinParticipants;
constraint CircularTables * BoardsPerCircular + RectangularTables * BoardsPerRectangular >= MinBoards;

% Objective
var int: TotalGuests = CircularTables * GuestsPerCircular + RectangularTables * GuestsPerRectangular;
solve maximize TotalGuests;

% Output
output ["Circular Tables: ", show(CircularTables), "\n",
        "Rectangular Tables: ", show(RectangularTables), "\n",
        "Total Guests: ", show(TotalGuests)];