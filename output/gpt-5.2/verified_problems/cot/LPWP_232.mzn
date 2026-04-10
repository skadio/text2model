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
var 0..(TotalSpace div min(SpacePerCircular, SpacePerRectangular)): CircularTables;
var 0..(TotalSpace div min(SpacePerCircular, SpacePerRectangular)): RectangularTables;

var 0..(TotalSpace div min(SpacePerCircular, SpacePerRectangular)) * max(ParticipantsPerCircular, ParticipantsPerRectangular): TotalParticipants;
var 0..(TotalSpace div min(SpacePerCircular, SpacePerRectangular)) * max(BoardsPerCircular, BoardsPerRectangular): TotalBoards;
var 0..(TotalSpace div min(SpacePerCircular, SpacePerRectangular)) * max(GuestsPerCircular, GuestsPerRectangular): TotalGuests;
var 0..TotalSpace: UsedSpace;

% Constraints
constraint
  UsedSpace = SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables;

constraint
  UsedSpace <= TotalSpace;

constraint
  TotalParticipants =
    ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables;

constraint
  TotalBoards =
    BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables;

constraint
  TotalGuests =
    GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;

constraint
  TotalParticipants >= MinParticipants;

constraint
  TotalBoards >= MinBoards;

% Objective
solve maximize TotalGuests;