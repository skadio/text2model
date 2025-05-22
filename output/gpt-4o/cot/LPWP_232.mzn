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

% A derived bound for decision variables
int: MaxTables = TotalSpace div min(SpacePerCircular, SpacePerRectangular);

% Variables
var 0..MaxTables: CircularTables;
var 0..MaxTables: RectangularTables;

% Constraints
constraint
    SpacePerCircular * CircularTables +
    SpacePerRectangular * RectangularTables
    <= TotalSpace;

constraint
    ParticipantsPerCircular * CircularTables +
    ParticipantsPerRectangular * RectangularTables
    >= MinParticipants;

constraint
    BoardsPerCircular * CircularTables +
    BoardsPerRectangular * RectangularTables
    >= MinBoards;

% Objective
solve maximize
    GuestsPerCircular * CircularTables +
    GuestsPerRectangular * RectangularTables;