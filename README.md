# peeker
- Web予約時の診察券番号や、交通事故時の緊急連絡など、必要な情報を画像とともに登録しておけばスムースに確認できます。
- アプリ内データベースを使用するので、情報が外部漏洩するリスクが低いです。

# 機能
- 生体認証(作成済み、未実装 https://github.com/fanawa/peeker/pull/5)
- 登録内容
  - 画像(複数可)、　連絡先(複数可)、　URL、 メモ
- ホーム画面 リスト/アイコン表示に切り替え可能
- 詳細画面 登録した電話番号への発信、URLをブラウザ表示

<img width="200" alt="スクリーンショット 2024-08-09 15 46 08" src="https://github.com/user-attachments/assets/c6c44730-8b48-48c9-9a2d-7f6d52138a10">

<img width="200" alt="スクリーンショット 2024-08-09 15 44 29" src="https://github.com/user-attachments/assets/1d0bdefc-006f-47e3-beec-4b742e6621ae">

<img width="200" alt="スクリーンショット 2024-08-09 15 45 58" src="https://github.com/user-attachments/assets/2d2b4f99-b49f-4978-b10b-18b43a6825a3">


https://github.com/user-attachments/assets/befc1111-d480-48f7-afe9-161caf6b3b4c

# 開発環境
- Flutter/Dart
- 状態管理: GetX
- データベース: Isar
