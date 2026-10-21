# subski-runpod-comfyui-backend

サブスキで使う動画生成用ComfyUIのバックエンドを、Runpod Serverless（Load Balancer型）にデプロイするためのリポジトリ。

## デプロイ
- Runpod Serverless の GitHub 連携でビルドする（Dockerfile Path: `Dockerfile`）
- 初回以降の反映は GitHub の Release 作成で行う（push だけでは反映されない）

## エンドポイント設定
- Endpoint Type: Load Balancer / Max workers: 1 / Idle timeout: 300
- CUDA version: 12.8 以上をすべて選択
- Expose HTTP Ports: 8188
- 環境変数: PORT=8188, PORT_HEALTH=8188
- Health check endpoint: /system_stats

## 注意
- 公開リポジトリのため、APIキー・パスワード等は絶対にコミットしない（Runpod の環境変数で渡す）