# ステージ1: 依存関係のインストールとビルド
FROM node:18-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# ステージ2: 本番用の軽量なイメージを作成
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# --- ▼▼ ここから追加 ▼▼ ---
# セキュリティ向上のため、専用のユーザーとグループを作成
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
# --- ▲▲ ここまで追加 ▲▲ ---

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Next.jsが推奨する非rootユーザーで実行
USER nextjs

EXPOSE 3000
ENV PORT 3000

CMD ["npm", "start"]