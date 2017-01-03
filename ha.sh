eth0_ip=$(ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1)
eth1_ip=$(ifconfig eth1 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1)
eth2_ip=$(ifconfig eth2 | grep 'inet addr' | cut -d: -f2 | cut -d\  -f1)

# Delete the existing containers
#
docker stop home-assistant
docker stop mqtt
docker rm home-assistant
docker rm mqtt

rm -f home-assistant.db
rm -f home-assistant.log

# Create the containers
#
docker pull ncarlier/mqtt
docker create --name="mqtt" -P -p 1883:1883 ncarlier/mqtt

docker pull balloob/home-assistant
docker build -t local/home-assistant docker/
docker create --name="home-assistant" -v '/home/docker/HomeAssistant:/config' -e "TZ=America/Chicago" --net=host local/home-assistant

# Launch the containers
#
docker start mqtt
docker start home-assistant
