# システム設計書

本ドキュメントは、要件定義に基づくFlutterアプリケーション（Dart実装）の全体設計をまとめたものです。システムの機能、アーキテクチャ、UI/UX、データ設計、状態管理、プロジェクト構成、および環境管理について記述しています。

---

## 1. システム概要

### 1.1 プロジェクト目的
- **打楽器資産管理:**  
  各楽器の基本情報（識別番号、モデル、購入日、状態など）の登録・表示・編集、所有者管理、メンテナンス記録、検索・フィルタリング、およびダッシュボードでの各種レポート表示を実現する。

- **打楽器の調達管理・予算管理:**  
  購入検討資産の状況（各楽器のモデル、価格、購入理由、状態情報〔pending, delivering, arrived〕）を確認し、予算ダッシュボード画面で年度ごとの購入必要資産と予算額をDrag and Dropで管理する。

- **新規入団者向けナレッジ管理:**  
  マニュアルやFAQ、運営ルールなどのコンテンツを統一された形式で管理し、コンテンツの作成／更新、バージョン管理、フィードバック収集を行う。

---

## 2. システムアーキテクチャ

### 2.1 フロントエンド（Flutter側）
- **アーキテクチャ:**  
  MVVM（Model-View-ViewModel）パターンを採用。  
  - **Model:** 要件定義のテーブル定義（User, Asset, AcquisitionAsset, Knowledge）に対応するデータモデルをDartで実装。
  - **View:** 各画面やウィジェット（資産一覧画面、購入検討資産画面、予算管理画面、ナレッジ管理画面など）。
  - **ViewModel/Provider:** 状態管理のために Provider または Riverpod を利用し、画面とデータ層の連携を担う。

- **画面/コンポーネントの構成例:**
  - ログイン画面  
  - ホームダッシュボード  
  - 打楽器資産管理画面（一覧、詳細、編集画面）  
  - 購入検討資産管理画面（詳細、申請状況、購入理由の記録）  
  - 予算管理ダッシュボード画面（Drag and Dropで管理）  
  - ナレッジ管理画面（ドキュメント作成／更新、フィードバック機能）

### 2.2 バックエンドとの連携
- **API連携:**  
  基本的にはREST APIでバックエンドと連携する想定。APIレスポンスは、要件定義のデータモデルに準拠し、Flutter側ではJSONパースしてModelインスタンスにマッピングする。  
- **ローカルキャッシュ:**  
  必要に応じてSQFLiteやHiveを利用して、オフライン時の一時データ保存を実装する。

---

## 3. データ層の設計

各テーブル定義に基づき、以下のDartクラスを実装する。

- **User:**  
  `user_id`, `first_name`, `last_name`, `email`, `role`, `password_hash`, `created_at`, `updated_at`

- **Asset:**  
  `asset_id`, `asset_code`, `category`, `model`, `price`, `owner`（User参照）、`short_description`, `description`, `purchase_date`, `degradation`, `storage_location`, `status`, `last_maintenance_date`, `attatchment`, `related_url`, `worknotes`, `created_at`, `updated_at`

- **AcquisitionAsset:**  
  `acquisition_asset_id`, `asset_name`, `model`, `vendor`, `estimated_cost`, `calculation_details`, `currency`, `purchase_reason`（理由づけ）、`status`（pending, delivering, arrived）、`requested_by`（User参照）、`requested_date`, `created_at`, `updated_at`

- **Knowledge:**  
  `knowledge_id`, `title`, `content`, `category`, `author`（User参照）、`version`, `is_published`, `created_at`, `updated_at`

各モデルは、JSONシリアライズ／デシリアライズのための仕組み（例えばjson_serializableパッケージなど）を採用し、APIとのデータ交換に活用する。

---

## 4. UI/UX設計

### 4.1 主要画面
- **ログイン画面:**  
  ユーザー認証（メールアドレス／パスワード）を実施し、ログイン後は各機能画面に遷移する。
  
- **ホームダッシュボード:**  
  グラフやチャートを用いて、全体の状況（資産状態、在庫、予算残高など）を表示する。
  
- **打楽器資産管理画面:**  
  楽器情報一覧、検索／フィルタ機能、資産の新規登録・編集・削除機能。
  
- **購入検討資産管理画面:**  
  購入検討対象の一覧表示、詳細画面（モデル、価格、購入理由、状態の確認と更新）を実装。
  
- **予算管理ダッシュボード:**  
  Drag and Dropによる年度別購入検討資産の整理・予算額とのマッチングを実現。ドラッグ＆ドロップ可能なウィジェットで、予算配分や費用予測の見直しを行う。
  
- **ナレッジ管理画面:**  
  ドキュメントの一覧表示、詳細、作成／編集、検索機能。フィードバック機能（コメント、レビュー）を備える。

### 4.2 画面遷移
- 各画面間の遷移は、FlutterのNavigator 2.0もしくは他のルーティングライブラリ（例：go_router）を利用して実装。  
- ユーザーの操作に合わせて、エラーハンドリングやローディングインジケーターの表示を適宜実装する。

---

## 5. 状態管理

- **推奨ライブラリ:** Providerまたは Riverpod  
- **設計方針:**  
  - 各画面用に ViewModel (StateNotifier や ChangeNotifier) を用意し、UIとデータ層の分離を実現する。  
  - API通信、データキャッシュ、ローカルストレージ更新時の状態変化を、Reactiveに反映する仕組みを整備する。

---

## 6. プロジェクト構成
  以下は、推奨されるディレクトリ構成と各ディレクトリの役割の詳細です:
  
  /myapp
  ├── lib
  │   ├── models/             
  │   │     - user.dart                    // Userデータモデル
  │   │     - asset.dart                   // 資産データモデル
  │   │     - acquisition_asset.dart       // 購入検討資産データモデル
  │   │     - knowledge.dart               // ナレッジデータモデル
  │   ├── providers/                     
  │   │     - user_provider.dart           // ユーザー認証、プロフィール管理
  │   │     - asset_provider.dart          // 資産情報のCRUD、検索、フィルタリング
  │   │     - acquisition_provider.dart    // 購入検討資産の申請、更新、状態管理
  │   ├── services/                      
  │   │     - api_client.dart              // REST API通信クライアント（http/dio利用）
  │   │     - local_db.dart                // SQFLite/Hiveを利用したローカルデータ保存
  │   ├── screens/                         
  │   │     - login_screen.dart              // ログイン画面
  │   │     - home_screen.dart               // ホームダッシュボード
  │   │     - asset_screen.dart              // 資産一覧／詳細／編集画面
  │   │     - acquisition_screen.dart        // 購入検討資産管理画面
  │   │     - budget_dashboard.dart          // 予算管理ダッシュボード（Drag and Drop実装）
  │   │     - knowledge_screen.dart          // ナレッジ管理画面
  │   ├── widgets/                         
  │   │     - custom_button.dart             // 汎用ボタン等
  │   │     - asset_card.dart                // 資産情報を表示するカード
  │   │     - loading_indicator.dart         // ローディング表示ウィジェット
  │   ├── utils/                           
  │   │     - constants.dart                 // 各種定数（テーマ、APIエンドポイント等）
  │   │     - theme.dart                     // アプリ全体のテーマ設定（Material Designのカスタマイズ）
  │   ├── routes.dart                        // Navigator / go_routerによるルート定義
  │   └── main.dart                          // アプリエントリーポイント
  │   ├── pubspec.yaml                         // パッケージと依存関係の定義
  │   └── test/                               // 単体テスト、ウィジェットテスト、統合テスト
  │
  ## 7. API設計とデータ通信
  
  - **API契約:**
    - RESTfulなAPIエンドポイントを前提とし、各リソース（User, Asset, AcquisitionAsset, Knowledge）に対して以下のCRUD操作を提供:
      - GET /users, GET /assets, GET /acquisition_assets, GET /knowledge
      - POST /assets, POST /acquisition_assets, POST /knowledge
      - PUT /assets/{id}（更新）など
      - DELETE /assets/{id}（削除）など
    - 各レスポンスはJSON形式。各モデルはfromJson/toJsonメソッド（json_serializable等の自動生成も検討）を実装し、データ交換を行う。
  
  - **エラーハンドリング:**
    - HTTPステータスコードに基づいたエラーメッセージの表示と、ログ出力を実装する。
  
  ## 8. 詳細な状態管理戦略
  
  - **選定理由:** ProviderまたはRiverpodにより、ViewModel（ChangeNotifier/StateNotifier）を用いて各画面・コンポーネントのロジックを分離する。
  
  - **実装例:**
    - **user_provider.dart:**  
      ユーザー認証状態、ログイン／ログアウトの処理、ユーザー情報の変更を管理する。
  
    - **asset_provider.dart:**  
      資産情報の取得、登録、更新、削除、検索フィルタリングのロジックを実装。API呼び出しとローカルキャッシュの同期を行う。
  
    - **acquisition_provider.dart:**  
      購入検討資産の申請、更新（例：ステータス変更: pending → delivering → arrived）、及び関連情報（購入理由、コメント）の管理を担当する。
  
  ## 9. 詳細なUI/UX設計
  
  - **デザインガイドライン:**
    - Material Design 2/3をベースに、統一感あるカラーパレットとフォント設定を実装。
    - 各画面はレスポンシブ対応を考慮し、モバイルでの利用感を最優先する。
  
  - **画面毎の詳細:**
    - **ログイン画面:**  
        シンプルなフォームレイアウト、エラーメッセージ表示、オプションでソーシャルログイン（必要に応じて）。
  
    - **ホームダッシュボード:**  
        各種指標（資産状態、在庫数、予算残高）をグラフ（fl_chart等を利用）で表示。タップすると詳細画面へ遷移。
  
    - **資産管理画面:**  
        リストViewまたはGridViewで資産の概要を表示。詳細画面では、編集／削除機能とともに履歴情報、メンテナンス記録をタブ切替で表示。
  
    - **購入検討資産管理画面:**  
        各購入検討対象のモデル、価格、購入理由、状態（pending, delivering, arrived）を一覧に表示。詳細画面で状態変更やコメント入力が可能。
  
    - **予算管理ダッシュボード:**  
        Drag and Dropウィジェットを活用し、年度ごとに区分された購入検討資産を予算額と連動させ、予算配分や調整シミュレーションを可能にする。
  
    - **ナレッジ管理画面:**  
        Markdownレンダリングを利用し、記事の詳細表示、コメント／レビュー機能、検索機能を持つ一覧画面を実装。
  
  - **画面遷移とナビゲーション:**
    - Flutterの Navigator 2.0 または go_router を用いて、明確なルート設計を行う。  
    - ユーザー操作に応じたエラーハンドリング、ローディングインジケーター、そしてスムーズなアニメーション遷移を実現する。
  
  ## 10. テスト戦略
  
  - **単体テスト:**
    - 各データモデルのfromJson/toJsonメソッドや、Providerのロジック部分を中心に実装する。
  
  - **ウィジェットテスト:**
    - 主要な画面やウィジェット（例：ログインフォーム、資産カード）のレンダリング、ユーザーインタラクションをテストする。
  
  - **統合テスト:**
    - ログインから各画面遷移、データ更新の一連のフローに対するテストを実施し、エッジケースも検証する。
  
  ## 11. 環境管理とデプロイ戦略
  
  - **ブランチ管理:**
    - 開発環境 (dev): ブランチ名 `develop`
    - ステージング環境 (staging): ブランチ名 `staging`
    - 本番環境 (prod): ブランチ名 `main` または `master`
  
  - **環境変数の管理:**
    - APIエンドポイント、認証キー等は .env ファイル等で管理し、ビルド時に注入する仕組みを採用する。
  
  - **CI/CD:**
    - GitHub ActionsやGitLab CI/CDを利用し、自動テスト、ビルド、デプロイパイプラインを構築する。
  
  ## 12. 今後の拡張性
  
  - 発注管理の強化: 購入検討資産の状態遷移に応じた自動通知、承認プロセス、ワークフローの拡充
  - 詳細な予算管理: シミュレーション機能、費用分析レポートの自動生成
  - ナレッジ管理: コンテンツの承認プロセス、多段階バージョン管理の実装
  
  ## 13. 補足
  
  - 本設計は初期リリース向けの基本機能実装を前提としているため、実装進捗やユーザーフィードバックに応じて設計の継続的なアップデートが必要。
  - UI/UX、API契約、データベース構造など、実際の運用に合わせた再検討を定期的に実施する。 