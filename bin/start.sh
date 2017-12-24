#!/bin/sh
docker rm -f $(docker ps -a -q)
echo "Enter your project name"
read project

echo "Enter your host name"
read host
rm .env
rm $PWD/nginx/symfony.conf
cp $PWD/nginx/symfony.conf.dist $PWD/nginx/symfony.conf
x='symfony'
y=$project
sed -i -e "s/$x/$y/g" $PWD/nginx/symfony.conf

rm $PWD/elk/logstash/logstash.conf
cp $PWD/elk/logstash/logstash.conf.dist $PWD/elk/logstash/logstash.conf
x='symfony'
y=$project
sed -i -e "s/$x/$y/g" $PWD/elk/logstash/logstash.conf

echo SYMFONY_APP_PATH=$project >> .env
echo VIRTUAL_HOST=$host >> .env

echo MYSQL_ROOT_PASSWORD=root >> .env
echo MYSQL_DATABASE=mydb >> .env
echo MYSQL_USER=user >> .env
echo MYSQL_PASSWORD=userpass >> .env

echo TIMEZONE=Europe/Paris >> .env

echo APP_ENV=dev >> .env
echo APP_DEBUG=1 >> .env
echo APP_SECRET=78e54f997c8e39e8b8988c0179856573 >> .env
echo '#TRUSTED_PROXIES=127.0.0.1,127.0.0.2' >> .env
echo '#TRUSTED_HOSTS=localhost,example.com' >> .env

echo DATABASE_URL=mysql://user:userpass@db:3306/mydb >> .env
echo MAILER_URL=smtp://mailcatcher:1025 >> .env

cd $PWD/projects
git clone https://github.com/symfony/skeleton.git $project
cd ../
docker-compose build
docker-compose up -d
echo "Add this to your /etc/hosts file" $(docker network inspect bridge | grep Gateway | grep -o -E '[0-9\.]+')  $host
docker-compose exec php composer install










