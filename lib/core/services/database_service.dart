import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:ocevara/core/models/catch_log.dart';

// Use conditional import to prevent dart:html from breaking mobile builds
import 'web_stub.dart' if (dart.library.html) 'web_impl.dart';

// On Flutter web, sqflite is not supported.
// all sqflite usage will be guarded with kIsWeb so the web build never calls it.
// sqflite and path are still imported, they compile fine on web,
// they just must not be called at runtime on web.
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init() {
    if (kIsWeb) {
      _loadWebMem();
    }
  }

  //in memory fallback web only 
  final List<CatchLog> _mem = [];

  void _loadWebMem() {
    try {
      final jsonStr = WebStorage.get('ocevara_catches');
      if (jsonStr != null) {
        final List<dynamic> list = jsonDecode(jsonStr);
        _mem.clear();
        for (var item in list) {
          _mem.add(CatchLog.fromJson(item));
        }
      }
    } catch (e) {
      debugPrint('Error loading web catches: $e');
    }
  }

  void _saveWebMem() {
    try {
      final jsonStr = jsonEncode(_mem.map((c) => c.toJson()).toList());
      WebStorage.set('ocevara_catches', jsonStr);
    } catch (e) {
      debugPrint('Error saving web catches: $e');
    }
  }

  //SQLite mobile and desktop only 
  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDB('ocevara.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await _createCatchesTable(db);
        await _createZonesTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS catches');
          await _createCatchesTable(db);
        }
        if (oldVersion < 3) {
          await _createZonesTable(db);
        }
        if (oldVersion < 4) {
          try {
            await db.execute('ALTER TABLE catches ADD COLUMN species_name TEXT');
          } catch (e) {
            debugPrint('Error adding species_name column: $e');
          }
        }
      },
    );
  }

  Future<void> _createCatchesTable(Database db) async {
    await db.execute('''
CREATE TABLE catches (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  species_id TEXT NOT NULL,
  species_name TEXT,
  quantity REAL NOT NULL,
  avg_weight REAL,
  unit TEXT NOT NULL,
  lat REAL NOT NULL,
  lng REAL NOT NULL,
  date TEXT NOT NULL,
  image_path TEXT,
  synced INTEGER NOT NULL,
  metadata TEXT
)''');
  }

  Future<void> _createZonesTable(Database db) async {
    await db.execute('''
CREATE TABLE zones (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  reason TEXT NOT NULL,
  severity TEXT NOT NULL,
  center_lat REAL NOT NULL,
  center_lng REAL NOT NULL,
  radius_km REAL NOT NULL,
  status TEXT NOT NULL,
  short_description TEXT
)''');
  }

  //public API 
  Future<void> insertCatch(CatchLog catchLog) async {
    if (kIsWeb) {
      _mem.removeWhere((c) => c.id == catchLog.id);
      _mem.insert(0, catchLog);
      _saveWebMem();
      return;
    }
    final db = await _db;
    final json = catchLog.toJson();
    
    // converting metadata map to string for SQLite
    if (json['metadata'] != null) {
      json['metadata'] = jsonEncode(json['metadata']);
    }

    await db.insert('catches', json,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CatchLog>> getAllCatches(String userId) async {
    if (kIsWeb) {
      return List.unmodifiable(_mem.where((c) => c.userId == userId));
    }

    final db = await _db;
    final rows = await db.query(
      'catches',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    
    return rows.map((r) {
      final map = Map<String, dynamic>.from(r);
      // converting metadata string back to Map
      if (map['metadata'] != null && map['metadata'] is String) {
        map['metadata'] = jsonDecode(map['metadata'] as String);
      }
      return CatchLog.fromJson(map);
    }).toList();
  }

  Future<void> deleteCatch(String id) async {
    if (kIsWeb) {
      _mem.removeWhere((c) => c.id == id);
      _saveWebMem();
      return;
    }
    final db = await _db;
    await db.delete('catches', where: 'id = ?', whereArgs: [id]);
  }

  // zones API 
  Future<void> insertZone(Map<String, dynamic> zoneJson) async {
    if (kIsWeb) return;
    final db = await _db;
    await db.insert('zones', zoneJson, 
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllZones() async {
    if (kIsWeb) return [];
    final db = await _db;
    return await db.query('zones');
  }

  Future<void> clearZones() async {
    if (kIsWeb) return;
    final db = await _db;
    await db.delete('zones');
  }

  Future<void> close() async {
    if (kIsWeb) return;
    final db = await _db;
    await db.close();
  }
}
