
bundle install
bundle exec rackup -p 9292 config.ru &
wget http://127.0.0.1:9292/v1/instance/list

