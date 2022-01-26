//set table name
final String tableGames = "game";

///Set the column names
///
/// Author: F.Brecher
class GamesFields {
  static final String columnGamesId = "id";
  static final String columnGamesName = "name";
}

///This class help to work with the data's from the game table
///
/// Author: F.Brecher
class Game {
  int id;
  String name;

  Game({this.name});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      GamesFields.columnGamesName: name,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Game.fromMap(Map<String, dynamic> map) {
    id = map[GamesFields.columnGamesId];
    name = map[GamesFields.columnGamesName];
  }
}

class GameList {
  List<Game> games;
  GameList(this.games);

  GameList.fromJson(Map<String, dynamic> json) {
    if (json['games'] != null) {
      games = <Game>[];
      json['games'].forEach((v) {
        games.add(new Game.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.games != null) {
      data['games'] = this.games.map((v) => v.toMap()).toList();
    }
    return data;
  }
}
