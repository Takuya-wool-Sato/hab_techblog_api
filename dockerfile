# Dockerfile
FROM ruby:3.1.2

# 必要なパッケージをインストール
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /hab_techblog_api

# GemfileとGemfile.lockをコピー
COPY Gemfile /hab_techblog_api/Gemfile
COPY Gemfile.lock /hab_techblog_api/Gemfile.lock

# Bundlerをインストール
RUN gem install bundler

# Gemをインストール
RUN bundle install

# アプリケーションコードをコピー
COPY . /hab_techblog_api

# ポートを開放
EXPOSE 3000

# デフォルトのコマンドを設定
CMD ["rails", "server", "-b", "0.0.0.0"]
