# Retail CRM System

小売業向けCRMシステム - AWS上で動作する新商品通知システム

## 概要

このシステムは、新商品が入荷された際にLINE APIを通じてユーザーに通知を送る機能を備えたCRMシステムです。

### 主な機能

1. **認証機能**
   - AWS Cognito を使用したユーザー登録・ログイン
   - メールアドレスとパスワードによる認証
   - JWTトークンを利用したAPI認証

2. **新商品入荷通知機能**
   - DynamoDB による商品データの管理
   - 新商品追加時のLINE通知送信
   - API Gateway + Lambda による通知エンドポイント

## システム構成

```
├── terraform/
│   ├── environments/
│   │   ├── dev/          # 開発環境の設定
│   │   └── prod/         # 本番環境の設定（実装は別途）
│   ├── modules/
│   │   ├── cognito/      # Cognito モジュール
│   │   ├── dynamodb/     # DynamoDB モジュール
│   │   ├── lambda/       # Lambda モジュール
│   │   └── api_gateway/  # API Gateway モジュール
│   └── shared/           # 共通設定
└── src/
    └── lambda/           # Lambda関数のソースコード
```

## 技術スタック

- **クラウド:** AWS (Lambda, API Gateway, DynamoDB, Cognito)
- **プログラミング言語:** Python 3.9
- **データベース:** DynamoDB
- **通知:** LINE Messaging API
- **認証:** AWS Cognito
- **IaC:** Terraform

## セットアップ手順

### 前提条件

1. AWS CLIのインストールと設定
2. Terraformのインストール
3. LINE Messaging APIのチャネル作成

### LINE APIの設定

1. [LINE Developers Console](https://developers.line.biz/console/)にアクセス
2. 新規プロバイダーを作成
3. Messaging APIチャネルを作成
4. チャネルシークレットとチャネルアクセストークンを取得

### デプロイ手順

1. 環境変数の設定

```bash
# LINE API認証情報の設定
cp terraform/environments/dev/terraform.tfvars.example terraform/environments/dev/terraform.tfvars
# terraform.tfvarsを編集してLINE API認証情報を設定
```

2. Terraformの初期化と実行

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

## API仕様

### POST /notify

新商品を登録し、LINE通知を送信するエンドポイント

#### リクエスト

```json
{
  "product_id": "string",
  "name": "string",
  "category": "string",
  "price": number
}
```

#### レスポンス

```json
{
  "message": "Product saved and notification sent successfully",
  "product": {
    "product_id": "string",
    "name": "string",
    "category": "string",
    "price": number,
    "created_at": "string"
  }
}
```

## 開発環境のセットアップ

1. Pythonの仮想環境を作成

```bash
cd src/lambda
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

2. 環境変数の設定

```bash
export LINE_CHANNEL_SECRET=your-channel-secret
export LINE_CHANNEL_TOKEN=your-channel-token
```

## 注意事項

- 本番環境へのデプロイ時は、適切なセキュリティ設定を行ってください
- LINE API認証情報は適切に管理してください
- DynamoDBのバックアップ設定を確認してください

## ライセンス

MIT
