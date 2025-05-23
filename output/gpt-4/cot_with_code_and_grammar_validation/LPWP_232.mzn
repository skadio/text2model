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

% Variables
var 0..TotalSpace: CircularTables;
var 0..TotalSpace: RectangularTables;

% Constraints
constraint CircularTables * SpacePerCircular + RectangularTables * SpacePerRectangular <= TotalSpace;
constraint CircularTables * ParticipantsPerCircular + RectangularTables * ParticipantsPerRectangular >= MinParticipants;
constraint CircularTables * BoardsPerCircular + RectangularTables * BoardsPerRectangular >= MinBoards;

% Objective
var int: TotalGuests = CircularTables * GuestsPerCircular + RectangularTables * GuestsPerRectangular;
solve maximize TotalGuests;