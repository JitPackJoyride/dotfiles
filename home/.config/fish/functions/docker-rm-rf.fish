function docker-rm-rf
    docker ps -qa | xargs -r docker rm -f
end
