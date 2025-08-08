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

% Derived bounds for decision variables
int: maxCircular = TotalSpace div SpacePerCircular;
int: maxRectangular = TotalSpace div SpacePerRectangular;

% Variables
var 0..maxCircular: CircularTables;
var 0..maxRectangular: RectangularTables;

% Constraints
constraint
    SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables <= TotalSpace;

constraint
    ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables >= MinParticipants;

constraint
    BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables >= MinBoards;

% Objective
solve maximize
    GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;