
#create temp dir
New-Item -Path "c:\" -Name "dockertemp" -ItemType "directory"
Set-Location "c:\dockertemp"

#download the docker installation zip file.
Invoke-WebRequest -UseBasicParsing -OutFile docker-19.03.2.zip https://download.docker.com/components/engine/windows-server/19.03/docker-19.03.2.zip

#stop the docker service
Stop-Service docker

# Extract the archive.
Expand-Archive docker-19.03.2.zip -DestinationPath $Env:ProgramFiles -Force

#start docker
start-service docker

#Pull UCP images.  Update tags to match UCP versions
docker image pull docker/ucp-agent-win:3.2.1
docker image pull docker/ucp-dsinfo-win:3.2.1

#ucp prep script
$script = [ScriptBlock]::Create((docker run --rm docker/ucp-agent-win:3.2.1 windows-script | Out-String))

Invoke-Command $script

#docker swarm join
