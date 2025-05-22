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

% Derived constants for bounding the decision variables
int: MaxCircular    = TotalSpace div SpacePerCircular;
int: MaxRectangular = TotalSpace div SpacePerRectangular;

% Variables
var 0..MaxCircular:    CircularTables;
var 0..MaxRectangular: RectangularTables;

% Constraints
constraint
    CircularTables * SpacePerCircular +
    RectangularTables * SpacePerRectangular
    <= TotalSpace;

constraint
    CircularTables * ParticipantsPerCircular +
    RectangularTables * ParticipantsPerRectangular
    >= MinParticipants;

constraint
    CircularTables * BoardsPerCircular +
    RectangularTables * BoardsPerRectangular
    >= MinBoards;

% Objective
solve maximize
    CircularTables * GuestsPerCircular +
    RectangularTables * GuestsPerRectangular;