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
var 0..TotalSpace div max(1, SpacePerCircular): CircularTables;
var 0..TotalSpace div max(1, SpacePerRectangular): RectangularTables;

var 0..(TotalSpace div max(1, SpacePerCircular)) * ParticipantsPerCircular +
       (TotalSpace div max(1, SpacePerRectangular)) * ParticipantsPerRectangular: TotalParticipants;

var 0..(TotalSpace div max(1, SpacePerCircular)) * BoardsPerCircular +
       (TotalSpace div max(1, SpacePerRectangular)) * BoardsPerRectangular: TotalBoards;

var 0..(TotalSpace div max(1, SpacePerCircular)) * GuestsPerCircular +
       (TotalSpace div max(1, SpacePerRectangular)) * GuestsPerRectangular: TotalGuests;

% Constraints
constraint SpacePerCircular * CircularTables + SpacePerRectangular * RectangularTables <= TotalSpace;

constraint TotalParticipants =
  ParticipantsPerCircular * CircularTables + ParticipantsPerRectangular * RectangularTables;
constraint TotalParticipants >= MinParticipants;

constraint TotalBoards =
  BoardsPerCircular * CircularTables + BoardsPerRectangular * RectangularTables;
constraint TotalBoards >= MinBoards;

constraint TotalGuests =
  GuestsPerCircular * CircularTables + GuestsPerRectangular * RectangularTables;

% Objective
solve maximize TotalGuests;