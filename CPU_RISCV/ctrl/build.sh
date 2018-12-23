#set -e
dir=`dirname $0`
g++ $(dirname $0)/controller.cpp -std=c++14 -I /tmp/usr/local/include/ -L /tmp/usr/local/lib/ -lserial -lpthread -o $(dirname $0)/ctrl
#echo "dir::"
#echo `dirname $0`