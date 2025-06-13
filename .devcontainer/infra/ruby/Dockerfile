FROM ruby:3.4-bookworm

ENV TZ=Asia/Tokyo

ENV APP_ROOT /myapp
WORKDIR $APP_ROOT

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Task Runner のインストール
RUN curl -sL "https://github.com/go-task/task/releases/download/v3.9.0/task_linux_amd64.deb" -o task.deb && dpkg -i task.deb && rm task.deb

# ブランチ名がbashで表示されるようにカスタマイズ
COPY ../.bashrc /root/.bashrc

# keychainでgitのSSHキーを扱えるようにする。
RUN apt-get update && apt-get install -y keychain

# アプリ全体をコピー
COPY . .

# ポートを指定
EXPOSE 3000

# 以下3つはrailsをインストールしたらコメントアウトを解除してください。
# 必要ファイルをコピー
COPY ../Gemfile ../Gemfile.lock ./

# Gemインストール
RUN bundle install

# デフォルトコマンド
# CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p ${APP_PORT}"]