# Stage 1: TypeScript のコンパイル
FROM node:18 AS build
WORKDIR /app
# package.json, tsconfig.json, functions ディレクトリをコピー
COPY package.json .
COPY tsconfig.json .
COPY functions/ functions/
RUN npm install && npx tsc

# Stage 2: AWS Lambda 用ランタイムイメージへコピー
FROM public.ecr.aws/lambda/nodejs:18
WORKDIR ${LAMBDA_TASK_ROOT}
# production依存関係を解決
COPY package.json .
RUN npm install --production
# コンパイル成果物と .env をコピー
# ※ tsconfig.json の outDir が "app" のため、成果物は /app/app/simple_linebot_app.js にあります
COPY --from=build /app/app/simple_linebot_app.js ${LAMBDA_TASK_ROOT}/app.js
COPY .env ${LAMBDA_TASK_ROOT}/.env

# ローカル参照用に /app/dist を作成し、ファイルをコピー
RUN mkdir -p /app/dist && cp ${LAMBDA_TASK_ROOT}/app.js /tmp/app.js
# docker cp でファイルをコピーするため、ファイルのパーミッションを変更
RUN chmod 644 /tmp/app.js
# コピーは次のコマンドで行う
# docker cp lambda-service:/tmp/app.js ./build/app.js


CMD ["app.lambda_handler"]