# Claude CLI: Enhanced Redmine Installer 完全自動作成

あなたは経験豊富なDevOpsエンジニアとして、以下のプロジェクトを**完全に**作成してください。

## 🎯 目標
Windows用Redmine Enhanced Installerプロジェクトを作成し、GitHubで公開まで完了させる。

## 📋 実行内容

### Phase 1: プロジェクト構造作成
以下のディレクトリ構造を作成してください：

```
redmine-enhanced-installer/
├── src/
│   ├── wix/
│   ├── scripts/
│   └── resources/
├── templates/
├── config/
├── .github/workflows/
├── .vscode/
└── build/
```

コマンド:
```bash
mkdir -p redmine-enhanced-installer
cd redmine-enhanced-installer
mkdir -p src/{wix,scripts,resources}
mkdir -p templates config .github/workflows .vscode build
echo "1.0.0" > VERSION
git init
git branch -M main
```

### Phase 2: WiX Toolset設定ファイル作成

`src/wix/Product.wxs`を作成してください。内容は以下の仕様で：

- Bitnami Redmineベースインストーラー
- プラグイン自動統合（ガントチャート、EVM、Excel出力、レポート）
- Windows MSI形式
- サービス自動登録
- スタートメニュー統合

### Phase 3: 自動化スクリプト作成

以下のスクリプトファイルを作成：

1. `src/scripts/customize-redmine.rb` - Rubyプラグイン統合スクリプト
2. `src/scripts/install-plugins.bat` - Windowsプラグインインストーラー
3. `src/scripts/configure-excel.bat` - Excel機能設定
4. `src/scripts/start-redmine.bat` - Redmine起動スクリプト

### Phase 4: 設定ファイル作成

1. `config/excel-config.yml` - Excel機能詳細設定
   - レポートテンプレート定義
   - 出力フォーマット設定
   - チャート設定

### Phase 5: GitHub Actions CI/CD

`.github/workflows/build-installer.yml`を作成：
- Windows Server 2022環境
- WiX Toolsetインストール
- Bitnami Redmineダウンロード
- プラグインクローン・パッケージング
- MSIビルド・テスト
- リリース自動作成

### Phase 6: VS Code開発環境

以下のファイルを作成：
1. `.vscode/settings.json` - XML、PowerShell、Ruby対応設定
2. `.vscode/tasks.json` - ビルドタスク定義
3. `.vscode/extensions.json` - 推奨拡張機能リスト

### Phase 7: ドキュメント作成

1. `README.md` - 完全なプロジェクトドキュメント
   - インストール手順
   - 使用方法
   - 開発者ガイド
   - トラブルシューティング

2. `LICENSE` - MITライセンス

3. `.gitignore` - 適切な除外設定

### Phase 8: GitHub公開準備

GitHubリポジトリ作成用のシェルスクリプトを作成してください。

## ⚡ 重要な仕様

### 技術スタック
- **Base**: Bitnami Redmine 5.0.5
- **Installer**: WiX Toolset 3.11
- **CI/CD**: GitHub Actions
- **Plugins**:
  - redmine_gantt_chart
  - redmine_evm_plugin
  - redmine_xlsx_format_issue_exporter
  - redmine_reports

### インストーラー機能
- ワンクリックインストール
- 自動サービス登録
- プラグイン自動設定
- Excel機能統合
- 完全アンインストール対応

## 📤 最終成果物

以下をすべて含む完全なプロジェクト：
1. ✅ 動作するWindows MSIインストーラー
2. ✅ 完全自動化されたCI/CDパイプライン
3. ✅ 企業レベルのドキュメント
4. ✅ プロフェッショナルな開発環境
5. ✅ GitHub公開用スクリプト

## 🚀 実行指示

**今すぐ**上記仕様に基づいて、完全なプロジェクトを作成してください。各ファイルの内容を具体的に生成し、実行可能な状態で提供してください。

途中でエラーが発生した場合は代替案を提示し、最終的に動作する完全なプロジェクトを必ず完成させてください。
