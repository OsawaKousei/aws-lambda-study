// dotenv を用いて .env を読み込む
import "dotenv/config";

export const lambda_handler = async (event: any): Promise<any> => {
  const events = event.events;
  if (Array.isArray(events) && events.length > 0) {
    // 最初のイベントからreplyTokenを取得
    const replyToken = events[0].replyToken;

    // 環境変数からLINEチャネルアクセストークンを取得
    const channelAccessToken = process.env.LINE_CHANNEL_ACCESS_TOKEN;
    if (!channelAccessToken) {
      return {
        statusCode: 500,
        body: JSON.stringify({ error: "LINE_CHANNEL_ACCESS_TOKEN is not set" }),
      };
    }

    // LINE Reply API のエンドポイント
    const replyEndpoint = "https://api.line.me/v2/bot/message/reply";

    // 送信するメッセージ内容
    const replyPayload = {
      replyToken: replyToken,
      messages: [
        {
          type: "text",
          text: "Hello, user",
        },
      ],
    };

    try {
      const response = await fetch(replyEndpoint, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${channelAccessToken}`,
        },
        body: JSON.stringify(replyPayload),
      });

      if (!response.ok) {
        const errorText = await response.text();
        return {
          statusCode: response.status,
          body: JSON.stringify({ error: errorText }),
        };
      }

      const result = await response.json();
      return {
        statusCode: 200,
        body: JSON.stringify({ result: result }),
      };
    } catch (error: any) {
      return {
        statusCode: 500,
        body: JSON.stringify({ error: error.message }),
      };
    }
  }

  // イベントが存在しない場合はエラーを返却
  return {
    statusCode: 400,
    body: JSON.stringify({ error: "No events found" }),
  };
};
