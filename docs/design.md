# システム設計概要

このドキュメントでは、プロジェクトのアーキテクチャやコンポーネント設計の概要を示します。

## 1. アーキテクチャ構成

- **フロントエンド:** Flutter を使用したモバイルアプリケーション
- **内部モジュール:**
  - モデル層（例: `Instrument`, `User`）
  - 画面（`DashboardScreen`, `InstrumentListScreen`, `InstrumentEditScreen` など）
  - ウィジェット（共通の `AppDrawer` など）
- **コード解析:** Dart Code Metrics を利用したコード解析と依存関係の可視化

## 2. コンポーネントの依存関係

- **DashboardScreen:**  
  - `models` と `widgets` に依存
- **InstrumentListScreen / InstrumentEditScreen:**  
  - `models`、`widgets`、および `screens` 間の関連性
- ※ 詳細は、依存関係図（PlantUML で生成）を参照

## 3. 技術選定の理由

- **Flutter:** クロスプラットフォーム対応、迅速なUI構築が可能
- **Dart Code Metrics:** コード品質と依存関係の可視化による保守性向上のため 