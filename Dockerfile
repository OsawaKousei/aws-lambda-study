# Stage 1: TypeScript のコンパイル
FROM node:18 AS build
WORKDIR /app
COPY functions/hello_world.ts app.ts
RUN npm install -g typescript && tsc app.ts --target ES2020 --module commonjs

# Stage 2: AWS Lambda 用ランタイムイメージへコピー
FROM public.ecr.aws/lambda/nodejs:18
COPY --from=build /app/app.js ${LAMBDA_TASK_ROOT}
CMD ["app.lambda_handler"]