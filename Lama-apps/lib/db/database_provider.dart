import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/achievement_model.dart';
import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/model/left_to_solve_model.dart';
import 'package:lama_app/app/model/password_model.dart';
import 'package:lama_app/app/model/safty_question_model.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/userHasAchievement_model.dart';
import 'package:lama_app/app/model/subject_model.dart';
import 'package:lama_app/app/model/userSolvedTaskAmount_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/db/database_migrator.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';

///This file manage the database
///
///In this file the database will be create or update
///All methods to work with the database you will find here
///
/// Author: F.Brecher, L.Kammerer
/// latest Changes: 16.09.2021
class DatabaseProvider {
  int currentVersion = 2;
  int oldVersion = 0;

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  // /
  // /
  // /
  // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // /
  // /
  // /
  // /
  Database _database;

  ///Return the Database
  ///
  /// If the Database doesn't exist or is not on the current version
  /// createDatabase() is called
  ///
  /// {@return} Database

  Future<Database> get database async {
    if (_database != null) {
      if (await _database.getVersion() == currentVersion) {
        return _database;
      }
    }

    _database = await createDatabase();

    return _database;
  }

  // /
  // /
  // /
  // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // /
  // /
  // /
  // /
  // /Create or Update the Database
  // /
  // / open a new database or a database with an old Version.
  // /
  // / if there is no database all migrations will be called and the
  // / code will be execute
  // / if there is an old database, the migrations which have a
  // / newer version will be called and the code will be execute
  // /
  // /
  // /
  // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // /
  // /
  // /
  // /
  // / {@return} Database
  Future<Database> createDatabase() async {
    //get the Database Path for the current device
    String dbPath = await getDatabasesPath();
    if (_database != null) {
      //get the database Version on the device
      oldVersion = await _database.getVersion();
    }

    return await openDatabase(
      join(dbPath, "userDB.db"),
      version: currentVersion,
      //if there is no database on the device call onCreate
      onCreate: (Database database, int version) async {
        DBMigrator.migrations.keys.toList()
          ..sort()
          ..forEach((j) async {
            Map migrationsVersion = DBMigrator.migrations[j];
            migrationsVersion.keys.toList()
              ..sort()
              ..forEach((k) async {
                var script = migrationsVersion[k];
                await database.execute(script);
              });
          });
      },
      //if there is a database on the device, but the version is not the current version call onUpgrade
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        //Map the entry's from migrations new, which are higher then the oldVersion.
        var upgradeScripts = new Map.fromIterable(
            DBMigrator.migrations.keys.where((j) => j > oldVersion),
            key: (j) => j,
            value: (j) => DBMigrator.migrations[j]);

        if (upgradeScripts.length == 0) return;

        upgradeScripts.keys.toList()
          ..sort()
          ..forEach((j) async {
            Map migrationsVersion = upgradeScripts[j];
            migrationsVersion.keys.toList()
              ..sort()
              ..forEach((k) async {
                var script = migrationsVersion[k];
                await database.execute(script);
              });
          });
      },
    );
  }

  ///get all entry's from table User
  ///
  /// {@return} <List<User>>
  Future<List<User>> getUser() async {
    if (kIsWeb) {
      var box = Hive.box('database');
      String data = await box.get('users');
      List<User> userList = [];

      if (data != null) {
        var data1 = jsonDecode(data);
        print("my data " + data);

        data1["users"].forEach((v) {
          userList.add(User.fromJson(v));
        });
      }

      return userList;
    } else {
      final db = await database;

      var users = await db.query(tableUser, columns: [
        UserFields.columnId,
        UserFields.columnName,
        UserFields.columnGrade,
        UserFields.columnCoins,
        UserFields.columnIsAdmin,
        UserFields.columnAvatar,
        UserFields.columnHighscorePermission
      ]);

      List<User> userList = <User>[];

      users.forEach((currentUser) {
        User user = User.fromMap(currentUser);

        userList.add(user);
      });

      return userList;
    }
  }

  ///get all entry's from table Achievement
  ///
  /// {@return} <List<Achievement>>
  Future<List<Achievement>> getAchievements() async {
    if (!kIsWeb) {
      final db = await database;

      var achievements = await db.query(tableAchievements, columns: [
        AchievementsFields.columnAchievementsId,
        AchievementsFields.columnAchievementsName
      ]);

      List<Achievement> achievementList = <Achievement>[];

      achievements.forEach((currentAchievement) {
        Achievement achievement = Achievement.fromMap(currentAchievement);

        achievementList.add(achievement);
      });

      return achievementList;
    } else {
      var box = Hive.box('database');
      var data = box.get('achievementList');
      List<Achievement> achivements = [];

      if (data != null) {
        achivements =
            AchievementList.fromJson({"achievementList": jsonDecode(data)})
                .achivments;
      }
      return achivements;
    }
  }

  ///get all entry's from table UserHasAchievement
  ///
  /// {@return} <List<UserHasAchievement>>
  Future<List<UserHasAchievement>> getUserHasAchievements() async {
    if (!kIsWeb) {
      final db = await database;

      var userHasAchievements =
          await db.query(tableUserHasAchievements, columns: [
        UserHasAchievementsFields.columnUserId,
        UserHasAchievementsFields.columnAchievementId
      ]);

      List<UserHasAchievement> userHasAchievementList = <UserHasAchievement>[];

      userHasAchievements.forEach((currentAchievement) {
        UserHasAchievement userHasAchievement =
            UserHasAchievement.fromMap(currentAchievement);

        userHasAchievementList.add(userHasAchievement);
      });

      return userHasAchievementList;
    } else {
      var box = Hive.box('database');
      var data = box.get('userHasAchievementList');
      List<UserHasAchievement> achivements = [];

      if (data != null) {
        achivements = UserHasAchievementList.fromJson(
            {"userHasAchievementList": jsonDecode(data)}).achivments;
      }
      return achivements;
    }
  }

  ///get all entry's from table Game
  ///
  /// {@return} <List<Game>>
  Future<List<Game>> getGames() async {
    if (!kIsWeb) {
      final db = await database;

      var games = await db.query(tableGames,
          columns: [GamesFields.columnGamesId, GamesFields.columnGamesName]);

      List<Game> gameList = <Game>[];

      games.forEach((currentGame) {
        Game game = Game.fromMap(currentGame);

        gameList.add(game);
      });

      return gameList;
    } else {
      var box = Hive.box('database');
      var data = box.get('games');
      List<Game> games = [];

      if (data != null) {
        games = GameList.fromJson({"games": jsonDecode(data)}).games;
      }
      return games;
    }
  }

  ///get all entry's from table Highscores
  ///
  /// {@return} <List<Highscores>>
  Future<List<Highscore>> getHighscores() async {
    if (!kIsWeb) {
      final db = await database;

      var highscores = await db.query(tableHighscore, columns: [
        HighscoresFields.columnId,
        HighscoresFields.columnGameId,
        HighscoresFields.columnScore,
        HighscoresFields.columnUserId
      ]);

      List<Highscore> highscoreList = <Highscore>[];

      highscores.forEach((currentHighscore) {
        Highscore highscore = Highscore.fromMap(currentHighscore);

        highscoreList.add(highscore);
      });

      return highscoreList;
    } else {
      var box = Hive.box('database');
      var data = box.get('highscore');
      List<Highscore> highscores = [];

      if (data != null) {
        highscores =
            HighscoreList.fromJson({"highscore": jsonDecode(data)}).highScore;
      }

      return highscores;
    }
  }

  ///get the highscore from an user in a specific game from table highscore
  ///
  /// {@param} User user, int gameID
  ///
  /// {@return} <int>
  Future<int> getHighscoreOfUserInGame(User user, int gameID) async {
    if (!kIsWeb) {
      final db = await database;

      var highscore = await db.query(tableHighscore,
          columns: [
            HighscoresFields.columnId,
            HighscoresFields.columnGameId,
            HighscoresFields.columnScore,
            HighscoresFields.columnUserId
          ],
          where:
              "${HighscoresFields.columnUserId} = ? and ${HighscoresFields.columnGameId} = ?",
          whereArgs: [user.id, gameID],
          orderBy: "${HighscoresFields.columnScore} DESC",
          limit: 1);

      if (highscore.isNotEmpty) {
        return Highscore.fromMap(highscore.first).score;
      }

      return 0;
    } else {
      var box = Hive.box('database');
      var data = box.get('highscore');
      List<Highscore> highscores = [];

      if (data != null) {
        highscores = HighscoreList.fromJson({"highscore": jsonDecode(data)})
            .highScore
            .where((e) => e.gameID == gameID && e.userID == user.id);
      }
      if (highscores.isNotEmpty) {
        return highscores.first.score;
      }

      return 0;
    }
  }

  /// get the highscore from a game from table highscore
  ///
  /// {@param} int gameID
  ///
  /// {@return} <int>
  Future<int> getHighscoreOfGame(int gameID) async {
    if (!kIsWeb) {
      final db = await database;

      var highscore = await db.query(tableHighscore,
          columns: [
            HighscoresFields.columnId,
            HighscoresFields.columnGameId,
            HighscoresFields.columnScore,
            HighscoresFields.columnUserId
          ],
          where: "${HighscoresFields.columnGameId} = ?",
          whereArgs: [gameID],
          orderBy: "${HighscoresFields.columnScore} DESC",
          limit: 1);

      if (highscore.isNotEmpty) {
        return Highscore.fromMap(highscore.first).score;
      }

      return 0;
    } else {
      var box = Hive.box('database');
      var data = box.get('highscore');
      List<Highscore> highscores = [];

      if (data != null) {
        highscores = HighscoreList.fromJson({"highscore": jsonDecode(data)})
            .highScore
            .where((e) => e.gameID == gameID);
      }
      if (highscores.isNotEmpty) {
        return highscores.first.score;
      }
      return 0;
    }
  }

//get a list from typ Subject from the database.
  ///get all entry's from table Subject
  ///
  /// {@return} <List<Subject>>
  Future<List<Subject>> getSubjects() async {
    if (!kIsWeb) {
      final db = await database;

      var subjects = await db.query(tableSubjects, columns: [
        SubjectsFields.columnSubjectsId,
        SubjectsFields.columnSubjectsName
      ]);

      List<Subject> subjectList = <Subject>[];

      subjects.forEach((currentSubject) {
        Subject subject = Subject.fromMap(currentSubject);

        subjectList.add(subject);
      });

      return subjectList;
    } else {
      var box = Hive.box('database');
      var data = box.get('subjects');
      List<Subject> subjectList = [];

      if (data != null) {
        subjectList =
            SubjectList.fromJson({"subjects": jsonDecode(data)}).subjectsList;
      }

      return subjectList;
    }
  }

  ///get all entry's from table UserSolvedTaskAmount
  ///
  /// {@return} <List<UserSolvedTaskAmount>>
  Future<List<UserSolvedTaskAmount>> getUserSolvedTaskAmount() async {
    if (!kIsWeb) {
      final db = await database;

      var userSolvedTaskAmounts =
          await db.query(tableUserSolvedTaskAmount, columns: [
        UserSolvedTaskAmountFields.columnUserId,
        UserSolvedTaskAmountFields.columnSubjectId,
        UserSolvedTaskAmountFields.columnAmount
      ]);

      List<UserSolvedTaskAmount> userSolvedTaskAmountList =
          <UserSolvedTaskAmount>[];

      userSolvedTaskAmounts.forEach((currentUserSolvedTaskAmount) {
        UserSolvedTaskAmount userSolvedTaskAmount =
            UserSolvedTaskAmount.fromMap(currentUserSolvedTaskAmount);

        userSolvedTaskAmountList.add(userSolvedTaskAmount);
      });

      return userSolvedTaskAmountList;
    } else {
      var box = Hive.box('database');
      var data = box.get('userSolvedTaskAmountList');
      List<UserSolvedTaskAmount> userSolvedTaskAmountList = [];

      if (data != null) {
        userSolvedTaskAmountList = UserSolvedTaskAmountList.fromJson(
                {"userSolvedTaskAmountList": jsonDecode(data)})
            .userSolvedTaskAmountList;
      }

      return userSolvedTaskAmountList;
    }
  }

  ///get all entry's from table TaskUrl
  ///
  /// {@return} <List<TaskUrl>>
  Future<List<TaskUrl>> getTaskUrl() async {
    if (!kIsWeb) {
      final db = await database;

      var taskUrl = await db.query(tableTaskUrl,
          columns: [TaskUrlFields.columnId, TaskUrlFields.columnTaskUrl]);

      List<TaskUrl> taskUrlList = <TaskUrl>[];

      taskUrl.forEach((currentTaskUrl) {
        TaskUrl taskUrl = TaskUrl.fromMap(currentTaskUrl);

        taskUrlList.add(taskUrl);
      });

      return taskUrlList;
    } else {
      var box = Hive.box('database');
      var data = box.get('taskUrlFieldslList');
      List<TaskUrl> taskUrlFieldslList = [];

      if (data != null) {
        taskUrlFieldslList =
            TaskUrlList.fromJson({"taskUrlFieldslList": jsonDecode(data)})
                .taskUrlFieldslList;
      }

      return taskUrlFieldslList;
    }
  }

  /// insert an new User in the table User
  ///
  /// {@param} User user
  ///
  /// {@return} <User> with the autoincremented id
  Future<User> insertUser(User user) async {
    if (!kIsWeb) {
      final db = await database;
      user.id = await db.insert(tableUser, user.toMap());
      return user;
    } else {
      try {
        List<User> usersList = await getUser();
        print(
            "ALL USERS GOT IN insertUser() : Users Found ${usersList.length}");

        var maxId = 0;

        if (usersList != null) {
          for (User item in usersList) {
            if (item.isAdmin) {
              continue;
            }
            if (item.id > maxId) maxId = item.id;
          }
        } else {
          usersList = [];
        }

        user.id = maxId + 1;
        usersList.add(user);

        await saveUsers(usersList);

        return user;
      } catch (e) {
        print("ERROROROROROROROR");
        debugPrint(e.toString());
      }
    }
  }

  saveUsers(List<User> users) async {
    var box = Hive.box('database');

    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (users != null) {
      data["users"] = users.map((v) => v.toMap()).toList();
    }
    print("here is my data " + jsonEncode(data).toString());
    await box.put('users', jsonEncode(data).toString());
  }

  /// insert an new Achievement in the table Achievement
  ///
  /// {@param} Achievement achievement
  ///
  /// {@return} <Achievement> with the autoincremented id
  Future<Achievement> insertAchievement(Achievement achievement) async {
    if (!kIsWeb) {
      final db = await database;
      achievement.id = await db.insert(tableAchievements, achievement.toMap());
      return achievement;
    } else {
      //new code using hive
      AchievementList achivements = AchievementList([]);

      var box = Hive.box('database');

      var achievementList = box.get('achievementList');

      var maxId = 0;

      if (achievementList != null) {
        achivements = AchievementList.fromJson(
            {"achievementList": jsonDecode(achievementList)});

        for (var item in achivements.achivments) {
          if (item.id > maxId) maxId = item.id;
        }
      }

      achievement.id = maxId + 1;
      achivements.achivments.add(achievement);
      var data = achivements.toJson()["achievementList"];

      await box.put('achievementList', data.toString());

      return achievement;
    }
  }

  /// insert an new userId and an achievementId in the table UserHAsAchievement
  ///
  /// {@param} User user, Achievement achievement
  insertUserHasAchievement(User user, Achievement achievement) async {
    if (!kIsWeb) {
      final db = await database;
      UserHasAchievement userHasAchievement =
          UserHasAchievement(userID: user.id, achievementID: achievement.id);
      await db.insert(tableUserHasAchievements, userHasAchievement.toMap());
    }
  }

  /// insert an new Game in the table Game
  ///
  /// {@param} Game game
  ///
  /// {@return} <Game> with the autoincremented id
  Future<Game> insertGame(Game game) async {
    if (!kIsWeb) {
      final db = await database;
      game.id = await db.insert(tableGames, game.toMap());
      return game;
    } else {
      GameList dataLst = GameList([]);

      var box = Hive.box('database');
      var games = box.get('games');
      var maxId = 0;

      if (games != null) {
        dataLst = GameList.fromJson({"games": jsonDecode(games)});

        for (var item in dataLst.games) {
          if (item.id > maxId) maxId = item.id;
        }
      }

      game.id = maxId + 1;
      dataLst.games.add(game);
      var data = dataLst.toJson()["games"];

      box.put('games', data.toString());

      return game;
    }
  }

  /// insert an new Highscore in the table Highscore
  ///
  /// {@param} Highscore highscore
  ///
  /// {@return} <Highscore> with the autoincremented id
  Future<Highscore> insertHighscore(Highscore highscore) async {
    if (!kIsWeb) {
      final db = await database;
      highscore.id = await db.insert(tableHighscore, highscore.toMap());
      return highscore;
    } else {
      highscore.id = 1;
      return highscore;
    }
  }

  /// insert an new Subject in the table Subject
  ///
  /// {@param} Subject subject
  ///
  /// {@return} <Subject> with the autoincremented id
  Future<Subject> insertSubject(Subject subject) async {
    if (!kIsWeb) {
      final db = await database;
      subject.id = await db.insert(tableSubjects, subject.toMap());
      return subject;
    } else {
      subject.id = 1;
      return subject;
    }
  }

  /// insert an UserId, a subjectId and an amount in the table UserSolvedTaskAmount
  ///
  /// {@param} User user, Subject subject, int amount
  insertUserSolvedTaskAmount(User user, Subject subject, int amount) async {
    if (!kIsWeb) {
      final db = await database;
      UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
          userId: user.id, subjectId: subject.id, amount: amount);
      await db.insert(tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap());
    }
  }

  /// insert a new TaskUrl in the table TaskUrl
  ///
  /// {@param} TaskUrl taskUrl
  ///
  /// {@return} <TaskUrl> with the autoincremented id
  Future<TaskUrl> insertTaskUrl(TaskUrl taskUrl) async {
    if (!kIsWeb) {
      final db = await database;
      taskUrl.id = await db.insert(tableTaskUrl, taskUrl.toMap());
      return taskUrl;
    } else {
      taskUrl.id = 1;
      return taskUrl;
    }
  }

  /// delete an user in table User
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteUser(int id) async {
    if (!kIsWeb) {
      final db = await database;
      return await db.delete(tableUser,
          where: "${UserFields.columnId} = ?", whereArgs: [id]);
    } else {
      var users = await getUser();
      var selectedUser = users.where((e) => e.id == id).first;
      users.remove(selectedUser);
      await saveUsers(users);

      return 1;
    }
  }

  /// delete an achievement in table Achievement
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteAchievement(int id) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.delete(tableAchievements,
          where: "${AchievementsFields.columnAchievementsId} = ?",
          whereArgs: [id]);
    }
  }

  /// delete an entry in table UserHasAchievement
  ///
  /// {@param} User user, Achievement achievement
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteUserHasAchievement(
      User user, Achievement achievement) async {
    if (!kIsWeb) {
      final db = await database;
      return await db.delete(tableUserHasAchievements,
          where:
              "${UserHasAchievementsFields.columnUserId} = ? and ${UserHasAchievementsFields.columnAchievementId} = ? ",
          whereArgs: [user.id, achievement.id]);
    } else {
      return 1;
    }
  }

  /// delete a game in table Game
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteGame(int id) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.delete(tableGames,
          where: "${GamesFields.columnGamesId} = ?", whereArgs: [id]);
    } else {
      return 1;
    }
  }

  /// delete a highscore in table Highscore
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteHighscore(int id) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.delete(tableHighscore,
          where: "${HighscoresFields.columnId} = ?", whereArgs: [id]);
    } else {
      return 1;
    }
  }

  /// delete an subject in table Subject
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows

  Future<int> deleteSubject(int id) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.delete(tableSubjects,
          where: "${SubjectsFields.columnSubjectsId} = ?", whereArgs: [id]);
    } else {
      return 1;
    }
  }

  /// delete an entry in table UserSolvedTaskAMount
  ///
  /// {@param} User user, Subject subject
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteUserSolvedTaskAmount(User user, Subject subject) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.delete(tableUserSolvedTaskAmount,
          where:
              "${UserSolvedTaskAmountFields.columnSubjectId} = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
          whereArgs: [subject.id, user.id]);
    } else {
      return 1;
    }
  }

  /// delete a taskUrl in table TaskUrl
  ///
  /// {@param} int id
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> deleteTaskUrl(int id) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.delete(tableTaskUrl,
          where: "${TaskUrlFields.columnId} = ?", whereArgs: [id]);
    }
    return 1;
  }

  /// update an user in table User
  ///
  /// {@param} User user
  ///
  /// {@return} <User>
  Future<User> updateUser(User user) async {
    if (!kIsWeb) {
      final db = await database;

      Password pswd = await _getPassword(user);
      User newUser = User(
          name: user.name,
          password: pswd.password,
          grade: user.grade,
          coins: user.coins,
          isAdmin: user.isAdmin,
          avatar: user.avatar);

      int updated = await db.update(tableUser, newUser.toMap(),
          where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }

    Password pswd = await _getPassword(user);
    User newUser = User(
        name: user.name,
        password: pswd.password,
        grade: user.grade,
        coins: user.coins,
        isAdmin: user.isAdmin,
        avatar: user.avatar);
    //
    // int updated = await db.update(tableUser, newUser.toMap(),
    //     where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);
    //
    // if (updated != null) {
    //   return await _getUser(user.id);
    // }

    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    newUser.id = selectedUser.id;
    newUser.highscorePermission = selectedUser.highscorePermission;
    users.remove(selectedUser);
    users.add(newUser);

    await saveUsers(users);

    return null;
  }

  /// update the name from an user in table User
  ///
  /// {@param} User user, String name
  ///
  /// {@return} <User>
  Future<User> updateUserName(User user, String name) async {
    if (!kIsWeb) {
      final db = await database;

      int updated = await db.update(
          tableUser, <String, dynamic>{UserFields.columnName: name},
          where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }
    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.name = name;
    users.add(selectedUser);
    await saveUsers(users);

    return selectedUser;
  }

  /// update the grade from an user in table User
  ///
  /// {@param} User user, int grade
  ///
  /// {@return} <User>
  Future<User> updateUserGrade(User user, int grade) async {
    if (!kIsWeb) {
      final db = await database;

      int updated = await db.update(
          tableUser, <String, dynamic>{UserFields.columnGrade: grade},
          where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }
    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.grade = grade;
    users.add(selectedUser);
    await saveUsers(users);

    return selectedUser;
  }

  /// update the coins from an user in table User
  ///
  /// {@param} User user, int coins
  ///
  /// {@return} <User>
  Future<User> updateUserCoins(User user, int coins) async {
    if (!kIsWeb) {
      final db = await database;

      int updated = await db.update(
          tableUser, <String, dynamic>{UserFields.columnCoins: coins},
          where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }

    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.coins = coins;
    users.add(selectedUser);
    await saveUsers(users);

    return selectedUser;
  }

  /// update the isAdmin field from an user in table User
  ///
  /// {@param} User user, bool isAdmin
  ///
  /// {@return} <User>
  Future<User> updateUserIsAdmin(User user, bool isAdmin) async {
    if (!kIsWeb) {
      final db = await database;

      int updated = await db.update(tableUser,
          <String, dynamic>{UserFields.columnIsAdmin: isAdmin ? 1 : 0},
          where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }

    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.isAdmin = isAdmin;
    users.add(selectedUser);
    await saveUsers(users);

    return selectedUser;
  }

  /// update the highscorePermission field from an user in table User
  ///
  /// {@param} User user, bool highscorePermission
  ///
  /// {@return} <User>
  Future<User> updateUserHighscorePermission(
      User user, bool highscorePermission) async {
    if (!kIsWeb) {
      final db = await database;

      int updated = await db.update(
          tableUser,
          <String, dynamic>{
            UserFields.columnHighscorePermission: highscorePermission ? 1 : 0
          },
          where: " ${UserFields.columnId} = ?",
          whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }
    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.highscorePermission = highscorePermission;
    users.add(selectedUser);
    await saveUsers(users);

    return selectedUser;
  }

  /// update the highscorePermission field for alle users in table User
  ///
  /// {@param} User user, bool highscorePermission
  ///
  /// {@return} <User>
  Future<void> updateAllUserHighscorePermission(List<User> userList) async {
    userList.forEach((user) async {
      await updateUserHighscorePermission(user, user.highscorePermission);
    });
  }

  /// update the avatar from an user in table User
  ///
  /// {@param} User user, String avatar
  ///
  /// {@return} <User>
  Future<User> updateUserAvatar(User user, String avatar) async {
    if (!kIsWeb) {
      final db = await database;

      int updated = await db.update(
          tableUser, <String, dynamic>{UserFields.columnAvatar: avatar},
          where: " ${UserFields.columnId} = ?", whereArgs: [user.id]);

      if (updated != null) {
        return await _getUser(user.id);
      }
      return null;
    }
    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.avatar = avatar;
    users.add(selectedUser);
    await saveUsers(users);
    return selectedUser;
  }

  /// update an achievement in table Achievement
  ///
  /// {@param} Achievement achievement
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateAchievement(Achievement achievement) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.update(tableAchievements, achievement.toMap(),
          where: " ${AchievementsFields.columnAchievementsId} = ?",
          whereArgs: [achievement.id]);
    }
    return 1;
  }

  /// update a game in table Game
  ///
  /// {@param} Game game
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateGame(Game game) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.update(tableGames, game.toMap(),
          where: "${GamesFields.columnGamesId} = ?", whereArgs: [game.id]);
    }
    return 1;
  }

  /// update a highscore in table Highscore
  ///
  /// {@param} Highscore highscore
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateHighscore(Highscore highscore) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.update(tableHighscore, highscore.toMap(),
          where: "${HighscoresFields.columnId} = ?", whereArgs: [highscore.id]);
    }
    return 1;
  }

  /// update a subject in table Subject
  ///
  /// {@param} Subject subject
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateSubject(Subject subject) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.update(tableSubjects, subject.toMap(),
          where: "${SubjectsFields.columnSubjectsId}  = ?",
          whereArgs: [subject.id]);
    }
    return 1;
  }

  /// update an entry in table UserSolvedTaskAmount
  ///
  /// {@param} User user, Subject subject, int amount
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateUserSolvedTaskAmount(
      User user, Subject subject, int amount) async {
    if (!kIsWeb) {
      final db = await database;
      UserSolvedTaskAmount userSolvedTaskAmount = UserSolvedTaskAmount(
          userId: user.id, subjectId: subject.id, amount: amount);

      return await db.update(
          tableUserSolvedTaskAmount, userSolvedTaskAmount.toMap(),
          where:
              "${UserSolvedTaskAmountFields.columnSubjectId}  = ? and ${UserSolvedTaskAmountFields.columnUserId} = ?",
          whereArgs: [subject.id, user.id]);
    }
    return 1;
  }

  /// update a taskUrl in table TaskUrl
  ///
  /// {@param} TaskUrl taskUrl
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updateTaskUrl(TaskUrl taskUrl) async {
    if (!kIsWeb) {
      final db = await database;

      return await db.update(tableTaskUrl, taskUrl.toMap(),
          where: " ${TaskUrlFields.columnId} = ?", whereArgs: [taskUrl.id]);
    }
    return 1;
  }

  /// checks if the transferred password is the password from the user
  ///
  /// {@param} String password, User user
  ///
  /// {@return} <int> true == 1, false == 0
  //check if the transferred password is the password from the user
  Future<int> checkPassword(String password, User user) async {
    if (!kIsWeb) {
      Password pswd = await _getPassword(user);
      return (password.compareTo(pswd.password) == 0 ? 1 : 0);
    }
    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;

    return (password.compareTo(selectedUser.password) == 0 ? 1 : 0);
  }

  /// update the password field in table User
  ///
  /// {@param} String newPassword, User user
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> updatePassword(String newPassword, User user) async {
    if (!kIsWeb) {
      final db = await database;
      Password password = Password(password: newPassword);
      return await db.update(tableUser, password.toMap(),
          where: "${UserFields.columnId} = ?", whereArgs: [user.id]);
    }

    var users = await getUser();
    var selectedUser = users.where((e) => e.id == user.id).first;
    users.remove(selectedUser);
    selectedUser.password = newPassword;
    users.add(selectedUser);
    await saveUsers(users);

    return 1;
  }

  Future<SaftyQuestion> _insertSaftyQuestion(
      SaftyQuestion saftyQuestion) async {
    if (!kIsWeb) {
      final db = await database;
      saftyQuestion.id =
          await db.insert(tableSaftyQuestion, saftyQuestion.toMap());
      return saftyQuestion;
    }
    List<SaftyQuestion> questions = await getSaftyQuestions();
    questions.add(saftyQuestion);
    await saveSaftyQuestion(questions);

    return saftyQuestion;
  }

  saveSaftyQuestion(List<SaftyQuestion> questions) async {
    var box = Hive.box('database');

    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (questions != null) {
      data["questions"] = questions.map((v) => v.toMap()).toList();
    }

    await box.put('saftyQuestion', jsonEncode(data).toString());
  }

  Future<SaftyQuestion> updateSaftyQuestion(SaftyQuestion saftyQuestion) async {
    List<SaftyQuestion> questions = await getSaftyQuestions();
    if (questions != null && questions.isNotEmpty) {
      var question = questions.where((e) => e.id == saftyQuestion.id).first;
      questions.remove(question);
      questions.add(saftyQuestion);
      await saveSaftyQuestion(questions);
      return saftyQuestion;
    }

    return saftyQuestion;
  }

  Future<SaftyQuestion> getSaftyQuestion(int adminId) async {
    if (!kIsWeb) {
      final db = await database;
      var saftyQuestionMap = await db.query(tableSaftyQuestion,
          columns: [
            SaftyQuestionFields.columnSaftyQuestionId,
            SaftyQuestionFields.columnSaftyQuestionAdminId,
            SaftyQuestionFields.columnSaftyQuestion,
            SaftyQuestionFields.columnSaftyAnswer
          ],
          where: "${SaftyQuestionFields.columnSaftyQuestionAdminId} = ?",
          whereArgs: [adminId]);

      if (saftyQuestionMap.length > 0) {
        return SaftyQuestion.fromMap(saftyQuestionMap.first);
      } else {
        return null;
      }
    }

    List<SaftyQuestion> questions = await getSaftyQuestions();
    if (questions != null && questions.isNotEmpty) {
      return questions.where((e) => e.adminID == adminId).first;
    }

    return null;
  }

  getSaftyQuestions() async {
    var box = Hive.box('database');
    String data = await box.get('saftyQuestion');
    List<SaftyQuestion> questionsList = [];

    if (data != null) {
      var data1 = jsonDecode(data);
      print("my data " + data);

      data1["questions"].forEach((v) {
        questionsList.add(SaftyQuestion.fromMap(v));
      });
    }

    return questionsList;
  }

  Future<int> deleteSaftyQuestion(int adminId) async {
    List<SaftyQuestion> questions = await getSaftyQuestions();
    if (questions != null && questions.isNotEmpty) {
      questions.removeWhere((e) => e.adminID == adminId);
      await saveSaftyQuestion(questions);
    }

    return 1;
  }

  ///(private)
  ///get an user from table User
  ///
  /// {@param} int id
  ///
  /// {@return} <User>
  Future<User> _getUser(int id) async {
    if (!kIsWeb) {
      final db = await database;

      var users = await db.query(tableUser,
          columns: [
            UserFields.columnId,
            UserFields.columnName,
            UserFields.columnGrade,
            UserFields.columnCoins,
            UserFields.columnIsAdmin,
            UserFields.columnAvatar,
            UserFields.columnHighscorePermission
          ],
          where: "${UserFields.columnId} = ?",
          whereArgs: [id]);

      if (users.length > 0) {
        User user = User.fromMap(users.first);
        return user;
      }
      return null;
    }
    var users = await getUser();
    var user = users.where((e) => e.id == id).toList();

    if (user.isNotEmpty) {
      return user.first;
    }

    return null;
  }

  ///(private)
  ///get the password from an user from table User
  ///
  /// {@param} User user
  ///
  /// {@return} <Password>
  Future<Password> _getPassword(User user) async {
    if (!kIsWeb) {
      final db = await database;
      var passwords = await db.query(tableUser,
          columns: [UserFields.columnPassword],
          where: "${UserFields.columnId} = ?",
          whereArgs: [user.id]);
      if (passwords.length > 0) {
        Password pswd = Password.fromMap(passwords.first);
        return pswd;
      }
      return null;
    }

    List<User> dataLst = await getUser();

    if (dataLst.isNotEmpty) {
      return Password(password: dataLst.first.password, id: dataLst.first.id);
    }
    return null;
  }

  ///delete all entrys in all databases
  Future deleteDatabase() async {
    if (!kIsWeb) {
      final db = await database;
      await db.delete(tableUser);
      await db.delete(tableSaftyQuestion);
      await db.delete(tableAchievements);
      await db.delete(tableUserHasAchievements);
      await db.delete(tableGames);
      await db.delete(tableHighscore);
      await db.delete(tableHighscore);
      await db.delete(tableSubjects);
      await db.delete(tableUserSolvedTaskAmount);
      await db.delete(tableTaskUrl);
      await db.delete(tableLeftToSolve);
    }

    var box = Hive.box('database');
    var data = await box.deleteFromDisk();
  }

  /// insert a taskString, a leftToSolve value, an userId and a doesStill Exist Value in the table leftToSolve
  ///
  /// {@param} String taskString, int leftToSolve, User user
  ///
  /// {@return} <int> which represent the id

  ///

  Future<int> insertLeftToSolve(
      String taskString, int leftToSol, User user) async {
    LeftToSolve lts = LeftToSolve(
        taskString: taskString,
        leftToSolve: leftToSol,
        userLTSId: user.id,
        doesStillExist: 0);

    if (!kIsWeb) {
      final db = await database;
      return await db.insert(tableLeftToSolve, lts.toMap());
    }
    LeftToSolveList leftToSolve = LeftToSolveList([]);

    var box = Hive.box('database');
    var leftToSolveList = box.get('LeftToSolveList');
    var maxId = 0;

    if (leftToSolveList != null) {
      leftToSolve = LeftToSolveList.fromJson(
          {"LeftToSolveList": jsonDecode(leftToSolveList)});

      for (var item in leftToSolve.leftToSolve) {
        if (item.id > maxId) maxId = item.id;
      }
    }

    lts.id = maxId + 1;
    leftToSolve.leftToSolve.add(lts);
    var data = leftToSolve.toJson()["LeftToSolveList"];

    await box.put('LeftToSolveList', data.toString());
    // return await db.insert(tableLeftToSolve, lts.toMap());

    // debugPrint(
    //     "insertLeftToSolve() Called: Line : 1250 : File database_provider.dart");
    return lts.id;
  }

  /// get the leftToSolve value from a task with an specific user
  ///
  /// {@param} String taskString,  User user
  ///
  /// {@return} <int>
  Future<int> getLeftToSolve(String taskString, User user) async {
    // final db = await database;
    // print("looking up task with: " + taskString);
    // var leftToSolve = await db.query(tableLeftToSolve,
    //     columns: [LeftToSolveFields.columnLeftToSolve],
    //     where:
    //         "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields.columnUserLTSId} = ?",
    //     whereArgs: [taskString, user.id]);
    // if (leftToSolve.length > 0)
    //   return leftToSolve.first[LeftToSolveFields.columnLeftToSolve];
    // return Future.value(-3);
    // LeftToSolveList leftToSolve = LeftToSolveList([]);

    // var box = Hive.box('database');
    // var leftToSolveList = box.get('LeftToSolveList');
    // var maxId = 0;
    // LeftToSolve solve;
    // if (leftToSolveList != null) {
    //   leftToSolve = LeftToSolveList.fromJson(
    //       {"LeftToSolveList": jsonDecode(leftToSolveList)});

    //   for (LeftToSolve item in leftToSolveList.leftToSolve) {
    //     if (item.userLTSId == user.id && item.taskString == taskString) {
    //       solve = item;
    //       break;
    //     }
    //   }
    // }
    // if(solve== null){
    //   return
    // }
    // debugPrint(
    //     "getLeftToSolve() Called: Line : 1266 : File database_provider.dart");

    if (!kIsWeb) {
      final db = await database;
      print("looking up task with: " + taskString);
      var leftToSolve = await db.query(tableLeftToSolve,
          columns: [LeftToSolveFields.columnLeftToSolve],
          where:
              "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields.columnUserLTSId} = ?",
          whereArgs: [taskString, user.id]);
      if (leftToSolve.length > 0)
        return leftToSolve.first[LeftToSolveFields.columnLeftToSolve];
      return Future.value(-3);
    }
    return 1;
  }

  Future<void> removeUnusedLeftToSolveEntries(
      List<Task> loadedTasks, User user) async {
    if (!kIsWeb) {
      final db = await database;
      db.delete(tableLeftToSolve,
          where: "${LeftToSolveFields.columnUserLTSId} = ?",
          whereArgs: [user.id]);
      loadedTasks.forEach((task) {
        insertLeftToSolve(task.toString(), task.leftToSolve, user);
      });
    }
    return 1;
  }

  /// decrement the leftToSolve value from a task with an specific user
  ///
  /// {@param} Task t,  User user
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> decrementLeftToSolve(Task t, User user) async {
    if (!kIsWeb) {
      final db = await database;
      print("curVal: " + t.leftToSolve.toString());
      int newVal = max(t.leftToSolve - 1, -2);
      print("setting to: " + newVal.toString());
      return await db.update(tableLeftToSolve,
          <String, dynamic>{LeftToSolveFields.columnLeftToSolve: newVal},
          where:
              "${LeftToSolveFields.columnTaskString} = ? and ${LeftToSolveFields.columnUserLTSId} = ?",
          whereArgs: [t.toString(), user.id]);
    }
    return 1;
  }

  /// update the columns doesStillExist to 1 from all entry's where columnTaskString is the transferred task
  ///
  /// {@param} Task t
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> setDoesStillExist(Task t) async {
    if (!kIsWeb) {
      final db = await database;
      print("Set flag for " + t.toString());
      return await db.update(tableLeftToSolve,
          <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 1},
          where: "${LeftToSolveFields.columnTaskString} = ?",
          whereArgs: [t.toString()]);
    }
    // debugPrint(
    //     "setDoesStillExist() Called: Line : 1312 : File database_provider.dart");
    return 1;
  }

  /// delete all entry's where the column doesStillExist is 0
  ///
  /// {@return} <int> which shows the number of deleted rows
  Future<int> removeAllNonExistent() async {
    if (!kIsWeb) {
      final db = await database;
      int val = 0;
      return await db.delete(tableLeftToSolve,
          where: "${LeftToSolveFields.columnDoesStillExist} = ?",
          whereArgs: [val]);
    }
    // debugPrint(
    //     "removeAllNonExistent() Called: Line : 1324 : File database_provider.dart");
    return 1;
  }

  /// update all columns doesStillExist to 0
  ///
  /// {@return} <int> which shows the number of updated rows
  Future<int> resetAllStillExistFlags() async {
    if (!kIsWeb) {
      final db = await database;
      return await db.update(tableLeftToSolve,
          <String, dynamic>{LeftToSolveFields.columnDoesStillExist: 0});
    }

    // debugPrint(
    //     "resetAllStillExistFlags() Called: Line : 1340 : File database_provider.dart");
    return 1;
  }
}
