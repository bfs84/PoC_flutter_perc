# プロジェクト要件定義

このドキュメントは、本プロジェクトの要件定義を記述するためのものです。

## 1. 機能要件

- **打楽器資産管理**
  - 各楽器の基本情報（識別番号、モデル、購入日、状態情報など）の登録・表示・編集機能
- **打楽器の調達管理・予算管理**
  - 損耗度データや在庫状況に基づく発注判断支援機能
  - 各楽器のランニングコストおよび予算（年間の調達予算、実績、費用予測）の集計・管理機能
- **新規入団者向けマニュアルのナレッジ管理**
  - 練習方法、片付け方法、運営ルール等の統一されたドキュメント管理機能
  - コンテンツの作成／更新、バージョン管理、フィードバック収集機能

### 機能ごとの詳細要件

#### 1. 打楽器の利用状況の最適化
- **楽器基本情報管理:**  
  - 楽器の識別番号、モデル、購入日、状態情報（損耗度、動作状況など）の登録・表示
- **所有者管理:**  
  - ユーザー情報との連携、各楽器の所有者リストの管理
- **メンテナンス記録:**  
  - 定期メンテナンスの記録、メンテナンス履歴の一覧表示、次回予定の通知機能
- **検索・フィルタリング:**  
  - 楽器情報のキーワード検索、フィルター、並び替え機能
- **ホームダッシュボード:**  
  - ダッシュボード上で「損耗度の高い楽器リスト」や「必要予算額」などのレポートを提供する
  - 具体的なレポート項目は設計段階で検討する

#### 2. 打楽器の調達管理・予算管理
- **購入検討資産管理:**  
  - 購入検討資産のテーブルを参照し、各楽器のモデルおよび価格を確認  
  - 購入検討の理由づけが記録され、既存資産との紐付けや、新規資産不要の場合のメモが残される  
  - 購入検討の状態は「pending（申請中）」「delivering（配送中）」「arrived（到着済）」などで管理（発注管理としても機能）
- **予算管理:**
  - 予算ダッシュボード画面にて、Drag and Drop で年度別の必要購入資産を、予算額と照らし合わせながら管理  
  - 年間の調達予算、費用予測、実績の集計・表示

#### 3. 新規入団者向けマニュアルのナレッジ管理
- **ドキュメント管理:**  
  - マニュアルの作成、更新、バージョン管理
- **情報検索:**  
  - キーワードやカテゴリーによるコンテンツ検索機能
- **フィードバック・改善:**  
  - ユーザーからのフィードバック収集、改善提案の反映プロセス
- **教育・トレーニング:**  
  - 利用ガイド、FAQ、動画などコンテンツの管理と定期的な更新

## 2. 非機能要件

- テーブル定義:
  1. **ユーザー (user) テーブル**
     - `user_id`: INTEGER, PRIMARY KEY, AUTO_INCREMENT  
          // ユーザーを一意に識別するID。例: USR00001, USR00002...
     - `first_name`: VARCHAR(50)  
          // ユーザーの名（ファーストネーム）
     - `last_name`: VARCHAR(50)  
          // ユーザーの姓（ラストネーム）
     - `email`: VARCHAR(255), UNIQUE  
          // ログインおよび連絡用のメールアドレス（ユニーク制約付き）
     - `role`: VARCHAR(50)  
          // システム内でのユーザーの役割（例：担当者、管理者など）
     - `password_hash`: VARCHAR(255)  
          // パスワードのハッシュ値。セキュリティのため生のパスワードは保存しない
     - `created_at`: TIMESTAMP  
          // レコード作成日時。自動挿入推奨
     - `updated_at`: TIMESTAMP  
          // 最終更新日時。更新時に更新されること

  2. **資産 (asset) テーブル**
     - `asset_id`: INTEGER, PRIMARY KEY, AUTO_INCREMENT  
          // 資産を一意に識別するID。採番例: AST00001, AST00002, ...
     - `asset_code`: VARCHAR(50)  
          // 資産固有のコード。システム上の表示用ID
     - `category`: VARCHAR(50)  
          // 資産の種類。例：『皮もの』、『鍵盤』など、あらかじめ定義した選択肢
     - `model`: VARCHAR(100)  
          // 資産の機種やモデル名
     - `price`: DECIMAL(10,2)  
          // 購入時の価格。例：123456.78 (通貨単位は別途管理)
     - `owner`: INTEGER  
          // 所有者情報。userテーブルのuser_idを参照する外部キー（リファレンス）
     - `short_description`: TEXT  
          // 資産の簡易な説明。概要情報として利用
     - `description`: TEXT  
          // 詳細な説明文。仕様、特徴など詳細情報
     - `purchase_date`: DATE  
          // 購入日。YYYY-MM-DD 形式
     - `degradation`: TINYINT  
          // 損耗度。1:重大, 2:高, 3:中, 4:小, 5:なし（数値で表現）
     - `storage_location`: VARCHAR(100)  
          // 保管場所。具体的なロケーション情報
     - `status`: VARCHAR(50)  
          // 資産の状態。例：active, maintenance, retired など
     - `last_maintenance_date`: DATE  
          // 最新のメンテナンス実施日（記録があれば）
     - `attatchment`: TEXT  
          // 添付ファイル情報（ファイル名やパスなど、必要に応じたJSON形式など）
     - `related_url`: VARCHAR(255)  
          // 資産に関連する外部リンクURL（あれば）
     - `worknotes`: TEXT  
          // 資産に対する作業ノート／備考
     - `created_at`: TIMESTAMP  
          // レコードの作成日時
     - `updated_at`: TIMESTAMP  
          // レコードの最終更新日時

  3. **購入検討資産 (acquisition_asset) テーブル**
     - `acquisition_asset_id`: INTEGER, PRIMARY KEY, AUTO_INCREMENT
     - `asset_name`: VARCHAR(100), 購入検討対象名称
     - `model`: VARCHAR(100), モデルまたは型番
     - `vendor`: VARCHAR(100), ベンダー情報
     - `estimated_cost`: DECIMAL(10,2)  
          // 試算テーブルに合わせた見積価格。従来のcost_estimationを名称変更
     - `calculation_details`: TEXT  
          // 試算の詳細、内訳、計算根拠などの情報（新規追加）
     - `currency`: CHAR(3)  
          // 通貨コード。例: 'JPY'
     - `purchase_reason`: TEXT  
          // 購入検討の理由づけ（例：既存資産との紐付け、新規資産不要の場合のメモ）
     - `status`: VARCHAR(50)  
          // 購入検討資産の状態。例: pending（申請中）、delivering（配送中）、arrived（到着済）など
     - `requested_by`: INTEGER, FOREIGN KEY (user_id)
     - `requested_date`: DATE, 申請日
     - `created_at`: TIMESTAMP, 作成日時
     - `updated_at`: TIMESTAMP, 更新日時

  4. **ナレッジ (knowledge) テーブル**
     - `knowledge_id`: INTEGER, PRIMARY KEY, AUTO_INCREMENT
     - `title`: VARCHAR(255), タイトル
     - `content`: TEXT, コンテンツ（テキストまたはマークダウン）
     - `category`: VARCHAR(100), カテゴリまたはタグ
     - `author`: INTEGER, FOREIGN KEY (user_id)
     - `version`: INTEGER, バージョン番号
     - `is_published`: BOOLEAN, 公開状態
     - `created_at`: TIMESTAMP, 作成日時
     - `updated_at`: TIMESTAMP, 更新日時

- **データモデル & テーブル間リファレンス定義:**

  以下は、各テーブル間の関係性を示します:

  1. **ユーザー (user) と 資産 (asset)**
     - 1対多: 1人のユーザーが複数の資産を所有可能  
      → `asset.owner` は `user.user_id` を参照する外部キーです。

  2. **ユーザー (user) と 購入検討資産 (acquisition_asset)**
     - 1対多: 1人のユーザーが複数の購入検討資産の申請を行う  
      → `acquisition_asset.requested_by` は `user.user_id` を参照します。

  3. **ユーザー (user) と ナレッジ (knowledge)**
     - 1対多: 1人のユーザー（著者）が複数のナレッジ記事を作成する  
      → `knowledge.author` は `user.user_id` を参照します.

- **環境定義:**

  システムは以下の3つの環境で運用され、各環境は異なるブランチで管理します:

  - **開発環境 (dev):** ブランチ名 `develop`
  - **ステージング環境 (staging):** ブランチ名 `staging`
  - **本番環境 (prod):** ブランチ名 `main` (または `master`)