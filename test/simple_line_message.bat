@echo off

rem 送信するメッセージを設定
set "MESSAGE_TEXT=Hello, Lambda!"
set "REQUEST_MESSAGE={\"events\":[{\"type\":\"message\",\"replyToken\":\"dummyReplyToken\",\"source\":{\"userId\":\"U0123456789abcdef\",\"type\":\"user\"},\"timestamp\":1623867600000,\"message\":{\"id\":\"1234567890\",\"type\":\"text\",\"text\":\"%MESSAGE_TEXT%\"}}]}"

rem メッセージを送信
curl -X POST "http://localhost:9000/2015-03-31/functions/function/invocations" ^
-H "Content-Type: application/json" ^
-d "%REQUEST_MESSAGE%"

pause