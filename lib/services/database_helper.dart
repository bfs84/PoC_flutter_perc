import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;
  
  static Database? _database;
  
  DatabaseHelper._internal();
  
  Future<Database> get database async {
    // Webプラットフォームでの実行時はnullを返さないようにする
    if (kIsWeb) {
      throw Exception('WebプラットフォームではSQLiteは使用できません');
    }
    
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    // Webプラットフォームでの実行チェック
    if (kIsWeb) {
      throw Exception('WebプラットフォームではSQLiteは使用できません');
    }
    
    String path = join(await getDatabasesPath(), 'percussion_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }
  
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        username TEXT UNIQUE,
        email TEXT,
        password_hash TEXT,
        display_name TEXT,
        role TEXT,
        isActive INTEGER DEFAULT 1,
        phoneNumber TEXT,
        department TEXT,
        profile_image TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    
    // 初期管理者アカウントの作成
    await _createInitialAdminAccount(db);
  }
  
  Future<void> _createInitialAdminAccount(Database db) async {
    // 管理者アカウントが存在するか確認
    List<Map<String, dynamic>> users = await db.query('users', where: 'role = ?', whereArgs: ['admin']);
    
    if (users.isEmpty) {
      // デフォルトの管理者アカウントを作成
      String passwordHash = _hashPassword('admin123');
      await db.insert('users', {
        'userId': 1,
        'username': 'admin',
        'email': 'admin@example.com',
        'password_hash': passwordHash,
        'display_name': '管理者',
        'role': 'admin',
        'isActive': 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      print('初期管理者アカウントを作成しました: admin / admin123');
    }
  }
  
  // パスワードのハッシュ化
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // ユーザー認証
  Future<User?> authenticateUser(String username, String password) async {
    final db = await database;
    
    // パスワードハッシュ化
    String passwordHash = _hashPassword(password);
    
    // ユーザー検索
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, passwordHash],
    );
    
    if (results.isNotEmpty) {
      // SQLiteの結果をUserモデルに変換するために必要なフィールドを追加
      Map<String, dynamic> userData = Map<String, dynamic>.from(results.first);
      // UserモデルのJSONフォーマットに合わせて変換
      userData['userId'] = userData['id'] ?? 0;
      userData['displayName'] = userData['display_name'] ?? 'ユーザー';
      userData['isActive'] = true; // デフォルト値
      
      // 認証成功
      return User.fromJson(userData);
    }
    
    // 認証失敗
    return null;
  }
  
  // ユーザー登録
  Future<int> registerUser(Map<String, dynamic> userData) async {
    final db = await database;
    
    // パスワードハッシュ化
    String passwordHash = _hashPassword(userData['password']);
    
    Map<String, dynamic> userToInsert = {
      'username': userData['username'],
      'email': userData['email'],
      'password_hash': passwordHash,
      'display_name': userData['display_name'],
      'role': userData['role'] ?? 'user',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    return await db.insert('users', userToInsert);
  }
  
  // すべてのユーザーを取得
  Future<List<User>> getAllUsers() async {
    final db = await database;
    
    List<Map<String, dynamic>> results = await db.query('users');
    
    return results.map((map) => User.fromJson(map)).toList();
  }
} 